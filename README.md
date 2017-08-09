# pass-botp

A [pass](https://www.passwordstore.org/) extension for managing TOTP Backup Codes

## Usage

```
$ pass botp
Usage: pass botp [--clip,-c] pass-name
```

## Example

`pass-botp` assumes your backup codes are stored line by line.
E.g. `backup_codes.gpg`:

```
111 111
222 222
333 333
444 444
...
```

pass-botp will provide you with the first non-commented line, and then comment that line out:

```
$ pass botp backup_codes
111 111
```

`backup_codes.gpg` will now be:

```
# 111 111
222 222
333 333
444 444
...
```

On each subsequent run, `pass-botp` will give the next available backup code (in this case, `222 222`) until none remain.

## Copying to clipboard

Simply add `-c` or `--clip`

```
$ pass botp -c backup_codes
Copied Backup code for backup_codes to clipboard. Will clear in X seconds.
```
