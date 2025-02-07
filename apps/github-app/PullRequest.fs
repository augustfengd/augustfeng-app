module PullRequest

open Octokit

let approvePr (client : GitHubClient) repositoryOwner repositoryName n=
    let review = PullRequestReviewCreate()
    review.Event <- PullRequestReviewEvent.Approve
    client.PullRequest.Review.Create(repositoryOwner, repositoryName, n, review).Wait()
