namespace id.Tests


open Xunit
open Amazon.Lambda.TestUtilities

open id


module FunctionTest =
    [<Fact>]
    let ``Invoke Lambda Function``() =
        // arrange
        let lambdaFunction = Function()
        let context = TestLambdaContext()
        let input = 42
        let expected = "42"

        // act
        let actual = lambdaFunction.FunctionHandler input context

        // assert
        Assert.Equal(expected, actual)
