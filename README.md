# Dockerfiles

## Setup

```bash
git clone git@github.com:masahiro-kubota/Dockerfiles.git
ln -s Dockerfiles/Makefile Makefile
```

### For devcontainer development

```bash
# After the setup above, configure devcontainer for your target
make setup-devcontainer ros2        # for ROS2 development
make setup-devcontainer typescript  # for TypeScript development
```

## Usage

```bash
# Set default target (persists across sessions)
make set-target ros2        # or typescript

# Build and run with default target
make build
make run

# Override default target temporarily
make build DOCKER_TARGET=typescript
make run DOCKER_TARGET=typescript
```

## Container commands

```bash
# add apt packages in the container
apt-install <apt-package>
```
