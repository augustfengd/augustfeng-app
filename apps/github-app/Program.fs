open System
open System.Text
open System.Text.Json
open Secrets
open Microsoft.Extensions.Configuration
open System.Security.Cryptography
open Octokit
open Subprocess

type Flags =
    { ClientId : string
      SecretName : string }

type JwtHeader =
    { alg: string
      typ: string }

type JwtClaims =
      { iat: int64
        exp: int64
        iss: string }

let getFlags () =
    let configuration = ConfigurationBuilder()
                            .AddJsonFile("appsettings.json")
                            .AddEnvironmentVariables()
                            .Build()
    
    configuration.Get<Flags>()

let encodeBase64Url = Convert.ToBase64String >> _.Replace('+', '-').Replace('/','_') >> _.TrimEnd('=')

let makeJwtHeader () =
    { alg = "RS256"
      typ = "JWT" }

let makeJwtPayload clientId =
    { iat = System.DateTimeOffset.UtcNow.AddSeconds(-10).ToUnixTimeSeconds()
      exp = System.DateTimeOffset.UtcNow.AddMinutes(10).ToUnixTimeSeconds()
      iss = string clientId }
    
let buildSigner (pem : string) (data : byte array) =
    let rsa = RSA.Create()
    rsa.ImportFromPem(pem.AsSpan())
    rsa.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1)

let makeJwt header payload pem = 
    let sign = buildSigner pem
    let data = $"{header}.{payload}" |> Encoding.UTF8.GetBytes
    let signature = sign data |> encodeBase64Url
    $"%s{header}.%s{payload}.%s{signature}"
    
let makeGitHubAppClient jwt =
    let credentials = Credentials(jwt, AuthenticationType.Bearer)
    let client = GitHubClient(ProductHeaderValue("augustfeng-app-as-github-app-client"))
    client.Credentials <- credentials
    client.GitHubApps

let makeGitHubClient token =
    let credentials = Credentials(token)
    let client = GitHubClient(ProductHeaderValue("augustfeng-app-as-github-client"))
    client.Credentials <- credentials
    client

let getInstallation (client : IGitHubAppsClient) login = async {
    let! installations = client.GetAllInstallationsForCurrent() |> Async.AwaitTask
    return Seq.find (fun (installation : Installation) -> installation.Account.Login = login) installations
}

let run flags = async {
    let secretsManagerClient = buildClient()
    let! { PrivateKeyPem =  privateKeyPem } = getSecret secretsManagerClient flags.SecretName
    let header = makeJwtHeader () |> JsonSerializer.SerializeToUtf8Bytes |> encodeBase64Url
    let payload = makeJwtPayload flags.ClientId |> JsonSerializer.SerializeToUtf8Bytes |> encodeBase64Url
    let jwt = makeJwt header payload privateKeyPem
    let gitHubAppsClient = makeGitHubAppClient jwt
    let! installation = getInstallation gitHubAppsClient "augustfengd"
    let! installationToken = gitHubAppsClient.CreateInstallationToken(installation.Id) |> Async.AwaitTask
    let gitHubClient = makeGitHubClient installationToken.Token
    let ghCloneLearnThings = gh installationToken.Token "repo clone augustfengd/learn.things" "/tmp" |> Async.RunSynchronously
    return ()
 }

[<EntryPoint>]
let main _ =
    let flags = getFlags()
    run flags |> Async.RunSynchronously
    0
