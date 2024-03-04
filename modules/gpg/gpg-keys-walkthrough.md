## Prerequisites

Must already have installed:

```sh
brew install \
1password \
1password-cli \
gnupg \
pinentry-mac
```

### Configuration

Update gpg configuration

`~/.gnupg/gpg.conf`

```sh
# Most config borrowed from best practices in https://raw.githubusercontent.com/ioerror/duraconf/master/configs/gnupg/gpg.conf

# When outputting certificates, view user IDs distinctly from keys:
fixed-list-mode

# Display long key IDs (long keyids are more collision-resistant than short
# keyids, it's trivial to make a key with any desired short keyid):
keyid-format 0xlong

# When multiple digests are supported by all recipients, choose the strongest:
personal-digest-preferences SHA512 SHA384 SHA256

# This preference list is used for new keys and becomes the default for
# "setpref" in the edit menu
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

# Use an agent to secure access and context loading
# (similar arguments as https://www.debian-administration.org/users/dkg/weblog/64)
use-agent

# You should always know at a glance which User IDs gpg thinks are legitimately
# bound to the keys in your keyring:
verify-options show-uid-validity
list-options show-uid-validity

# When making an OpenPGP certification, use a stronger digest than the default:
cert-digest-algo SHA512

# Disable inclusion of the version string in ASCII armored output:
no-emit-version
```

`~/.gnupg/gpg-agent.conf`

```sh
default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
pinentry-program /opt/homebrew/bin/pinentry-mac
```

Append GPG init to shell sessions and enable SSH `~/.zshrc`

```sh
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
```

## Create Keys

```console
 ❯ gpg --full-generate-key
 (GnuPG) 2.4.0; Copyright (C) 2021 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 9
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: Testy McTesterson
Email address: McT@t.co
Comment:
You selected this USER-ID:
    "Testy McTesterson <McT@t.co>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: revocation certificate stored as '/Users/tyler/.gnupg/openpgp-revocs.d/F4CDAF37B82DEF37C3BB4783D58B6C8CFF9A094E.rev'
public and secret key created and signed.

pub   ed25519/0xD58B6C8CFF9A094E 2023-03-16 [SC]
      F4CDAF37B82DEF37C3BB4783D58B6C8CFF9A094E
uid                              Testy McTesterson <McT@t.co>
sub   cv25519/0x8A98F5619C7A8FE2 2023-03-16 [E]

 ❯ gpg --expert --edit-key 0xD58B6C8CFF9A094E
gpg (GnuPG) 2.4.0; Copyright (C) 2021 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   2  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 2u
sec  ed25519/0xD58B6C8CFF9A094E
     created: 2023-03-16  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  cv25519/0x8A98F5619C7A8FE2
     created: 2023-03-16  expires: never       usage: E
[ultimate] (1). Testy McTesterson <McT@t.co>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 11

Possible actions for this ECC key: Sign Authenticate
Current allowed actions: Sign

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? S

Possible actions for this ECC key: Sign Authenticate
Current allowed actions:

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? A

Possible actions for this ECC key: Sign Authenticate
Current allowed actions: Authenticate

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (2) Curve 448
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Fri Mar 15 14:51:52 2024 MDT
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  ed25519/0xD58B6C8CFF9A094E
     created: 2023-03-16  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  cv25519/0x8A98F5619C7A8FE2
     created: 2023-03-16  expires: never       usage: E
ssb  ed25519/0xF0397988F917B253
     created: 2023-03-16  expires: 2024-03-15  usage: A
[ultimate] (1). Testy McTesterson <McT@t.co>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 10
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (2) Curve 448
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Fri Mar 15 14:52:51 2024 MDT
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  ed25519/0xD58B6C8CFF9A094E
     created: 2023-03-16  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  cv25519/0x8A98F5619C7A8FE2
     created: 2023-03-16  expires: never       usage: E
ssb  ed25519/0xF0397988F917B253
     created: 2023-03-16  expires: 2024-03-15  usage: A
ssb  ed25519/0xC06AE5677774CA20
     created: 2023-03-16  expires: 2024-03-15  usage: S
[ultimate] (1). Testy McTesterson <McT@t.co>

gpg> save
```

<!-- TODO: Add revoke cert generation and storage -->

## Backup Keys

Export the keys you just created to a secure backup in 1password.

<!-- TODO: add metadate from keys to 1password storage -->

<!-- TODO: fix loading commands -->

```console
## Export keys from GPG
## Replace [email] in all the commands below with the email used for the key
## Replace [ultimate KEYID] in all commands below with the key-id
gpg --output \<[email]-pub\>.gpg --armor --export [ultimate KEYID]
gpg --output \<[email]-secret-keys\>.gpg --armor --export-secret-keys [ultimate KEYID]
gpg --output \<[email]-secret-subkeys\>.gpg --armor --export-secret-subkeys [ultimate KEYID]

## Load keys into 1Password
## Note: when loading be sure to escape `.` in the email, `\.`
op item create --account=my.1password.com --category="Secure Note" --title="[email] GPG Public Key Ultimate" --tags="gpg" '<[email]-pub>\.gpg[file]=./<[email]-pub>.gpg'
op item create --account=my.1password.com --category="Secure Note" --title="[email] GPG Secret Keys Ultimate" --tags="gpg" '<[email]-secret-keys>\.gpg[file]=./<[email]-secret-keys>.gpg'
op item create --account=my.1password.com --category="Secure Note" --title="[email] GPG Secret Subkeys" --tags="gpg" '<[email]-secret-subkeys>\.gpg[file]=./<[email]-secret-subkeys>.gpg'
```

## Remove Ultimate Key

!!DANGER!!

<!-- TODO: detail deleting and re-importing keys  -->
<!--
gpg --delete-secret-key [ultimate KEYID]
gpg --import \<[email]-secret-subkeys\>.gpg

# remove all the local key exports after verifying load into 1Password
 -->

## Configure git

### Configure Signing

Use the keyid for your [S] signing subkey to configure git

```console
gpg -K
ssb   cv25519/0x8A98F5619C7A8FE2 2023-03-16 [E]
ssb   ed25519/0xF0397988F917B253 2023-03-16 [A] [expires: 2024-03-15]
ssb   ed25519/0xC06AE5677774CA20 2023-03-16 [S] [expires: 2024-03-15]

# Configure git
# Make sure your email matches the email in the key!
# add the exclamation point to tell git it is a subkey
git config --global user.signingkey=F0397988F917B253!
git config --global commit.gpgsign=true
```

Copy your public PGP key to <https://gitlab.com/-/profile/gpg_keys>. It is the
contents of the file you created during the backup called `<[email]-pub>.gpg`

### Configure SSH with GPG

The config specified for your shell and gpg-agent above will allow the correct
key output from SSH.

Run `ssh-add -L` and copy the output to <https://gitlab.com/-/profile/keys>!

If the command shows `The agent has no identities.`, configure GPG with the key
to use for SSH:

```sh
> gpg -K --with-keygrip
/Users/sroberts/.gnupg/pubring.kbx
----------------------------------
sec   ed25519 2024-02-28 [SC]
      A48F48AE937A1B8A75A9F0BE48A86E318C5C966B
      Keygrip = FEE4C5BB7DC7E3D1A5F994B38650B08825F98969
uid           [ultimate] Stephen Roberts <sroberts@edg.io>
ssb   cv25519 2024-02-28 [E]
      Keygrip = E540A2FF6D364AB42013971AFA1A8C3E7C21B061
ssb   ed25519 2024-02-28 [A] [expires: 2025-02-27]
      Keygrip = C87DEC4D5B9630F5018D443B0379E18439A47FE6
ssb   ed25519 2024-02-28 [S] [expires: 2025-02-27]
      Keygrip = 6D3DB8BD7643AAC1EC51F530F92F61334957A5E1

> echo C87DEC4D5B9630F5018D443B0379E18439A47FE6 >>~/.gnupg/sshcontrol
> ssh-add -L
```

## References

An explainer for subkeys: <https://wiki.debian.org/Subkeys> PGP best practices:
<https://riseup.net/en/security/message-security/openpgp/gpg-best-practices>
