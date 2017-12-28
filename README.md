# EXPO-LIVRES

## Project
EXPO-LIVRES is an annual book-fair held by La Boutique du Livre where Manitoban librarians peruse and order many books for their organizations and schools.

This app enables customers to create a virtual "cart" by scanning barcodes with their device's camera. The "cart" is then uploaded during checkout, significantly speeding up checkout times.

## Getting Started

This project uses Carthage dependency manager to load 3rd party frameworks. It must be installed in order to build the project. Follow the provided steps to install via HomeBrew:

### Ensure HomeBrew Is Installed
- Run `$ brew --version` in terminal.
- You'll see something like `Homebrew 1.2.4` if it's installed.
- If not, go to https://brew.sh for installation instructions.

### Install Carthage
- With HomeBrew installed run `brew update` in terminal.
- Run `brew install carthage`.

### Install Dependencies
- With Carthage installed run `carthage bootstrap --platform iOS` in terminal. This command will need to be re-run periodically in the future as new versions of Xcode/Swift are installed. Build errors complaining about modules built with incompatible versions of Swift are usually resolved by running this command.

## Configuration
- Build configurations are set in Xcode by selecting the appropriate Scheme in top left corner. Current schemes include Testing, Debug, Release. Debug should be selected for general development.

## Application Architecture
- This app follows the Coordinator pattern as described by Soroush Khanlou here: http://khanlou.com/2015/10/coordinators-redux/.
