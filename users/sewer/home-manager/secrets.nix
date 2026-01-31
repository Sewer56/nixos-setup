let
  # SSH public key for user 'sewer'
  sewer = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkBdMm6zPIEUzwgMuhohmLtv7gNnMTBPqulOBOcsfq11t7UFKqFazufOIik91790to38oFISjq7n6xNj91jbR4EF1gQElnTDfCXkcebVGz16pf3QjtNn1p1kVeX49Z89hV6c37y5XKfUkbXwdEholNK+sDNj9w8l+ei/rOELDp9y07pw8+tLEo0YLxHPsd0pfw1BvT877tydR6T3gElB7w1wQpGPTErHoQkcP7TR9Sq9JHpfT3tAMfTTkdKY43Um1WrInJZTrkzl18HlfgudrcPhx8kC4Erayd2gEFl0RTI5RqsXbZ6Ng9EZIZ3ha8mwokM6RHTFKy+yBSigcGvQwh";
  users = [sewer];
in {
  # Example secrets - uncomment and modify as needed
  "secrets/wallhaven-api-key.age".publicKeys = users;
  "secrets/github-token.age".publicKeys = users;
  "secrets/nix-access-tokens.age".publicKeys = users;
  "secrets/nexus-api-key.age".publicKeys = users;
  "secrets/reloaded-wiki-search-github-api-key.age".publicKeys = users;

  # "api-token.age".publicKeys = users;
  # "database-password.age".publicKeys = users;
}
