### Why this exists

Going through the Flatiron web immersive means completing a lot of lessons. Mechanically, the way these lessons are processed and recognized by Learn.co is through the opening of pull requests from student forks of lesson repos. For some reason, they neglected to include closing the PR in their cli lesson submission logic, so students' github open pull requests number in the hundreds by the time they graduate. Github does not offer a way to easily bulk-close repos, so this simple script does that.

### Requirements

- Have Ruby and Bundler installed, version probably doesn't matter.
- Have a [Personal Access Token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) for your github account with repo access

### How to use it

1. clone this repo
2. run `cd learn_co_cleaner`
3. run `bundle install`
4. run `touch env.rb` 
5. open env.rb
6. add a `USER` variable equal to your github username as a string, case sensitive
7. add a `PAT` variable equal to your github personal access token as a string
8. close and save env.rb
9. run `./learn_co_cleaner`
10. watch as your open pull requests are closed, one by one. 
11. follow the prompt to delete your env file if desired

### FAQs

Why not just use real env vars?
- using a ruby env file with variables, followed by a call that deletes it is a quick, implicit contract with anyone of any skill level who uses this: they can know after using this tool, no trace of their personal access token will be left behind. the use of environment variables may cast doubt on this fact.

Why not just a real script with curls to the github api endpoints? 
- high-quality API wrappers are nice and handle all the errors for you

### license

Do whatever you want with this code, fork/modify/customize/redistribute, just don't use it to break anything or hurt anyone.
