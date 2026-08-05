# Secret Management with agenix

Secrets use [agenix](https://github.com/ryantm/agenix) and live in the private
submodule at `users/sewer/secrets`, not in this repo. To add, edit or rekey one,
see [its README](users/sewer/secrets/README.md).

Below is the one-time setup needed per machine.

## Setup for New Machine

### 1. Copy your private key

```bash
cp /path/to/your/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa
```

It's in the password manager. This one key both decrypts the secrets and
authenticates to GitHub for the private submodule.

If the key is in encrypted PKCS#1 format
(`-----BEGIN RSA PRIVATE KEY----- Proc-Type: 4,ENCRYPTED`), convert it to
OpenSSH format first. This prompts for the passphrase:

```bash
ssh-keygen -p -f ~/.ssh/id_rsa
```

### 2. Verify GitHub access

```bash
ssh -T git@github.com     # expect: Hi Sewer56!
```

If it fails, add the key at <https://github.com/settings/keys>.

### 3. Fetch the submodule

Already done if you cloned with `--recurse-submodules`:

```bash
git submodule update --init --recursive
```

### 4. Test access

```bash
nix shell github:ryantm/agenix
cd users/sewer/secrets
for f in secrets/*.age; do
  agenix -d "$f" >/dev/null 2>&1 && echo "OK   $f" || echo "FAIL $f"
done
```

Every line must print `OK`. If they all fail, agenix isn't finding your key.
Pass it explicitly with `-i ~/.ssh/id_rsa`.

## Security Notes

- **Never commit private keys.**
- **Avoid `builtins.readFile`/`builtins.exec`** for secrets. They can expose
  values in the Nix store. Everything here decrypts at runtime; keep it that way.

## Useful Links

- [agenix Repository](https://github.com/ryantm/agenix)
- [NixOS Wiki - Secrets](https://nixos.wiki/wiki/Secrets)
