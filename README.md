# Archlinux Dev Container with AUR Support

This repository provides a Dockerfile to build an ArchLinux-based image with support for AUR (Arch User Repository) packages, leveraging `yay` as the AUR helper. The image is designed for flexibility and includes tools like `sudo`, `yq`, and HashiCorp's `consul`, `nomad`, `terraform`, and `vault`.

---

## Features

- Based on the official ArchLinux image.
- Includes `yay`, a powerful AUR helper, for managing AUR packages.
- Pre-installs the following tools:
  - `sudo`
  - `yq`
  - HashiCorp tools: `consul`, `nomad`, `terraform`, `vault`.
- Customizable to include additional AUR packages from a provided list. Default list: [caiodelgadonew/ansible-archlinux](https://github.com/caiodelgadonew/ansible-archlinux/blob/main/roles/archlinux/vars/main.yml)

---

## Build Instructions

To build the Docker image, use the following command:

```bash
docker build -t archlinux-devcontainer .
```

---

## Usage

### Running the Container
To run a container from the built image:

```bash
docker run -it archlinux-devcontainer /bin/zsh
```

### Customizing Installed Packages
The Dockerfile fetches a list of additional packages from an external YAML file. To modify this behavior, update the URL in the Dockerfile or provide your own YAML file:

```bash
RUN curl -s <your-yaml-file-url> | yq '.yay_packages[]' | xargs yay -S --noconfirm
```

---

## Pre-Installed Packages

### System Tools
- `sudo`
- `yq`

### HashiCorp Tools
- `consul`
- `nomad`
- `terraform`
- `vault`

### AUR Packages
The image dynamically installs additional AUR packages defined in an external YAML file. 
- Default list: [caiodelgadonew/ansible-archlinux](https://github.com/caiodelgadonew/ansible-archlinux/blob/main/roles/archlinux/vars/main.yml)

---

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this repository.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
