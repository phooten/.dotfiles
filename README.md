# General
Trying to figure out the best way to structure my personal env and tools:
- config files
- helper tools
- templates
- ...?

On thought is to follow: "My Dev Setup Is Better Than Yours" (Paid subscription $39)
https://frontendmasters.com/courses/developer-productivity-v2/

Free slides: https://frontendmasters.github.io/dev-prod-2/lessons/navigation/tmux
Example project: https://github.com/ThePrimeagen/.dotfiles/tree/master


# .configs
Repo to contain templates for my dot files and common executables


# .ssh Notes
## FAQ
### SSH Key Reset
_See: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent_
1. create a keygen
```bash
ssh-keygen -t rsa -b 4096 -C "parkerhooten@gmail.com"
```

2. start ssh-agent
```bash
eval "$(ssh-agent -s)"
```

3. Alter config file if needed
_Template can be found in the `ssh` directory_
```bash
Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
```

4. [ MAC only ]
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

5. Add public key to github / gitlab


Other Trouble shooting
- Check gitlab / github ssh keys in your profile settings

