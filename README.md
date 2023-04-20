# DirBuster Ruby

DirBuster-Ruby is a directory brute-force tool written in Ruby. It is a console application that takes a target URL and a wordlist of directory paths as input, and then scans the target server for directories that match the paths in the wordlist.

## Features

- Scans a target domain for directories using a wordlist
- Multi-threaded directory brute-forcing
- HTTP status code analysis (200, 403, 404, 301)
- Support for directories with encoded characters
- Interrupt handling for pausing and resuming scans
- User choice for displaying directory lists

## Requirements

- Ruby 2.7.0 or later
- Bundler gem

## Installation

- Clone this repository to your local machine.
- Navigate to the directory where the repository was cloned.
- Run bundle install to install the required gems.

## Usage

Run ruby dirbuster.rb to start the program. You will be prompted to enter the target domain and the wordlist file name. The wordlist file should be a text file with one directory path per line.

Example:

```
Input Target Domain: http://example.com
```

## Contributing

Contributions to DirBuster-Ruby are welcome! If you find any bugs or have suggestions for new features, please create a GitHub issue or submit a pull request.
