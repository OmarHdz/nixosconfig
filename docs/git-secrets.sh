#!/bin/bash

# Initialize git-secrets in the repository
git secrets --install -f

# Add custom pattern for github api tokes
git secrets --add 'gh[pousr]_[A-Za-z0-9]{36}'

# Add custom pattern for stripe api
git secrets --add 'sk_(live|test)_[A-Za-z0-9]{24}'

# Add custom pattern for deepseek api
git secrets --add 'sk_[A-Za-z0-9]{32}'

# Register AWS patterns (for aws services only)
# git secrets --secrets --register-aws

# Print success message
echo "git-secrets has been successfully configured and the hooks have been installed"
