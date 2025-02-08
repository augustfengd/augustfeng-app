namespace whoami


open System.Text.Json
open System.Text.Json.Serialization
open Amazon.Lambda.Core

open System


// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[<assembly: LambdaSerializer(typeof<Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer>)>]
()

type FunctionInput =
    { [<JsonPropertyName("key1")>]
      Key1 : string
      [<JsonPropertyName("key2")>]
      Key2 : string
      [<JsonPropertyName("key3")>]
      Key3 : string }

type Function() =
    /// <summary>
    /// A simple function that takes a string and does a ToUpper
    /// </summary>
    /// <param name="input">The event for the Lambda function handler to process.</param>
    /// <param name="context">The ILambdaContext that provides methods for logging and describing the Lambda environment.</param>
    /// <returns></returns>
    member __.FunctionHandler (input: obj) (_: ILambdaContext) =
        JsonSerializer.Serialize(input)
