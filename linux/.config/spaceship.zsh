# shellcheck shell=bash
 
spaceship add gradle

SPACESHIP_PROMPT_ORDER=(
  time          # Time stampt
  user          # Username
  dir           # Current directory
  host          # Hostname
  git           # Git repository details
  hg            # Mercurial repository details
  package       # Package version
  node          # Node.js version
  bun           # Bun version
  deno          # Deno version
  rust          # Rust version
  lua           # Lua version
  java          # Java version
  gradle        # Gradle version
  docker        # Docker version
  docker_compose # Docker Compose version
  ruby          # Ruby version
  elixir        # Elixir version
  xcode         # Xcode version
  zig           # Zig version
  pulumi        # Pulumi version
  terraform     # Terraform version
  kubectl       # Kubectl context
  aws           # Amazon Web Services profile
  gcloud        # Google Cloud Platform profile
  azure         # Azure profile
  venv          # Python virtualenv
  exec_time     # Execution time of the last command in seconds
  async         # Indicator for background jobs 
  line_sep      # Line break
  exit_code     # Exit code of the last command
  jobs          # Background jobs indicator
  char          # Prompt character
)

SPACESHIP_PACKAGE_SHOW_PRIVATE=true
