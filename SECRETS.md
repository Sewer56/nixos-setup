# Secret Management with agenix

This repository uses [agenix](https://github.com/ryantm/agenix) for secure secret management in NixOS.
Secrets are encrypted using SSH public keys and stored safely in the repository.

Below are examples for my user.

## How it Works

- **Public keys** are stored in `secrets.nix` (safe to commit)
- **Private keys** stay in your `~/.ssh/` directory (never committed)
- **Encrypted secrets** are stored as `.age` files (safe to commit)
- **Decryption** happens at runtime using your SSH private key

### How agenix Finds Your Private Key

agenix automatically finds your private key by:

1. **Checking SSH agent** (if running): `ssh-add -L`
2. **Looking in standard locations**: `~/.ssh/id_rsa`, `~/.ssh/id_ed25519`, etc.
3. **Matching keys**: For each private key found, derives the public key and matches against `secrets.nix`
4. **Using the match**: When found, uses that private key for encryption/decryption

**Manual override**: Use `agenix -i /path/to/key` to specify a specific private key

## Setup for New Machine

### 1. Copy Your Private Key

Transfer your SSH private key to the new machine:

```bash
# Copy your private key to ~/.ssh/
cp /path/to/your/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa
```

For me, it's in the password manager.

**If your private key is encrypted (PKCS#1 format):**
```bash
# First convert your key to OpenSSH format
ssh-keygen -p -f /home/sewer/.ssh/id_rsa
# This will prompt for your current passphrase
```

### 2. Install agenix CLI

```bash
nix shell github:ryantm/agenix
```

### 3. Test Access

Navigate to the home-manager directory and test decryption:

```bash
cd /etc/nixos/users/sewer/home-manager
# Test by trying to edit a secret (creates it in secrets/ folder)
agenix -e secrets/test.age
```

## Key Management

### Adding a New Key

1. **If you have an encrypted RSA private key** (format: `-----BEGIN RSA PRIVATE KEY----- Proc-Type: 4,ENCRYPTED`):
   
   ```bash
   # Copy your key to the standard location
   cp /path/to/your/rsa_key /home/sewer/.ssh/id_rsa
   chmod 600 /home/sewer/.ssh/id_rsa
   
   # Convert from PEM to OpenSSH format (will prompt for passphrase)
   ssh-keygen -p -f /home/sewer/.ssh/id_rsa
   
   # Extract public key
   ssh-keygen -y -f /home/sewer/.ssh/id_rsa > /home/sewer/.ssh/id_rsa.pub
   ```

2. **If you already have an OpenSSH key**, get the SSH public key:

   ```bash
   ssh-keygen -y -f /home/sewer/.ssh/id_rsa
   ```

3. Add to `users/sewer/home-manager/secrets.nix`:

   ```nix
   let
     newUser = "ssh-rsa AAAAB3NzaC1yc2EAAAA... new-key-here";
     users = [sewer newUser];
   in {
     "secrets/secret-name.age".publicKeys = users;
   }
   ```

4. Rekey all secrets:
   ```bash
   cd /etc/nixos/users/sewer/home-manager
   agenix -rIs
   ```

### Removing a Key

1. Remove from `users/sewer/home-manager/secrets.nix`
2. Rekey all secrets: 
   ```bash
   cd /etc/nixos/users/sewer/home-manager
   agenix -r
   ```

## Creating and Using Secrets

### 1. Define in users/sewer/home-manager/secrets.nix

```nix
{
  "secrets/my-secret.age".publicKeys = users;
}
```

### 2. Create the Secret

```bash
cd /etc/nixos/users/sewer/home-manager
agenix -e secrets/my-secret.age
```
This opens your `$EDITOR` to input the secret content.

### 3. Use in Home Manager

```nix
age.secrets.my-secret = {
  file = ./secrets/my-secret.age;
  path = "${config.home.homeDirectory}/.secrets/my-secret";
  mode = "600";  # File permissions
};
```

### 4. Access in Programs

The secret will be available at the specified path:
```nix
programs.someApp = {
  enable = true;
  secretFile = config.age.secrets.my-secret.path;
};
```

## Common Operations

**Note: All agenix commands must be run from the home-manager directory:**
```bash
cd /etc/nixos/users/sewer/home-manager
```

### List all secrets

```bash
ls secrets/
# Shows all .age files
```

### Edit existing secret

```bash
agenix -e secrets/secret-name.age
```

### Rekey all secrets (after adding/removing keys)

```bash
agenix -r
```

### Decrypt secret to stdout (for testing)

```bash
agenix -d secrets/my-secret.age
```

### Check if secrets are properly encrypted

```bash
cat secrets/my-secret.age
# Should show encrypted content, not plaintext
```

## Examples

### SSH Private Key

```nix
# In users/sewer/home-manager/secrets.nix
"secrets/ssh-private-key.age".publicKeys = users;

# In home-manager
age.secrets.ssh-private-key = {
  file = ./secrets/ssh-private-key.age;
  path = "${config.home.homeDirectory}/.ssh/id_rsa_secret";
  mode = "600";
};
```

### Email Password

```nix
# In users/sewer/home-manager/secrets.nix
"secrets/email-password.age".publicKeys = users;

# In home-manager
age.secrets.email-password = {
  file = ./secrets/email-password.age;
  path = "${config.home.homeDirectory}/.secrets/email-password";
  mode = "600";
};

# Use with Home Manager's built-in passwordCommand
accounts.email.accounts.work = {
  primary = true;
  address = "sewer@company.com";
  userName = "sewer@company.com";
  realName = "Sewer User";
  
  # Home Manager reads the password at runtime, not build time
  passwordCommand = ["cat" "${config.age.secrets.email-password.path}"];
  
  imap = {
    host = "imap.company.com";
    port = 993;
    tls.enable = true;
  };
  
  smtp = {
    host = "smtp.company.com";
    port = 587;
    tls = {
      enable = true;
      useStartTls = true;
    };
  };
};

# Enable email clients
programs.thunderbird.enable = true;
```

## Security Notes

- **Never commit private keys** to the repository
- **Always set proper file permissions** (usually 600 for secrets)
- **Rekey secrets** when removing access for users
- **Test secret access** after configuration changes
- **Avoid `builtins.readFile`** for secrets - it reads at evaluation time and can expose secrets in the Nix store
- **Use runtime approaches** like environment variables, program-specific secret file options, or shell substitution instead

## Useful Links

- [agenix Repository](https://github.com/ryantm/agenix)
- [agenix Tutorial](https://github.com/ryantm/agenix#tutorial)
- [NixOS Wiki - Secrets](https://nixos.wiki/wiki/Secrets)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)