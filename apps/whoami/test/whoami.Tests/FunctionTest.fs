namespace whoami.Tests


open Xunit
open Amazon.Lambda.TestUtilities

open whoami


module FunctionTest =
    [<Fact>]
    let ``Invoke ToUpper Lambda Function``() =
        // Invoke the lambda function and confirm the string was upper cased.
        let lambdaFunction = Function()
        let context = TestLambdaContext()
        let upperCase = lambdaFunction.FunctionHandler "hello world" context

        Assert.Equal("HELLO WORLD", upperCase)
