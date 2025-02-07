module Secrets

open System.Text.Json
open System.Text.Json.Serialization
open Amazon.SecretsManager
open Amazon.SecretsManager.Model

let buildClient () = new AmazonSecretsManagerClient()

type Secret = {
    [<JsonPropertyName("private-key.pem")>]
    PrivateKeyPem : string
}

let getSecret (client : AmazonSecretsManagerClient) name = async {
    let req = GetSecretValueRequest(SecretId = name)
    let! res = client.GetSecretValueAsync(req) |> Async.AwaitTask
    return JsonSerializer.Deserialize<Secret>(res.SecretString)
}
