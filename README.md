# MarvelBabel

Project based on **VIPER** and **Clean** architecture.

![VIPER scheme](https://github.com/babel-cdm/Resources/blob/master/CoVi/BabelViper.png)

## Structure

The project consists of 3 layers: **Presentation**, **Domain** and **Data**.
In this way, we will get a Clean architecture:
- Presentation is the application.
- Domain and Data are integrated as frameworks.

It has been done in this way to ensure that layers do not overlap where they should not. Creating the project with frameworks will force you **not** to import Data in the Domain layer, **nor** use the Presentation layer in the Domain and Data layers.

## Integrations

### App

The application consists of 2 views: a list and a detail.
In both screens, requests are made to Marvel services:

- In the listing, requests are made by pagination, so when reaching the end of the listing, it will load 20 more items.

- In the detail, it will call the WS of the Hero detail.

### SSL Pinning

SSL Pinning has been integrated in the calls to the WS, checking the certificate of ****.marvel.com***, previously stored in the Keychain.

A certificate renewal has also been implemented when the *Build* or *Version* of the App changes to a higher version.

Both with the certificate renewal and the first time the application is installed, it will take the **.marvel.com* certificate, and store it in the Keychain, for later reading and checking in the WS. Doing this will prevent the injection of certificates into the application by external programs, such as Frida.

### Encryption

All values that are stored in the UserDefaults, will be encrypted, making them difficult to read.
Currently the number of the current version of the application is stored, in order to compare if a certificate migration is needed.

### Dark mode

App supports dark mode.

### Tests

Only unit tests have been implemented.
