# 🚀 Automated deployment of a web page to AWS

## 📌 Description

This project implements automated deployment and updating of a simple web page to AWS using `hello.txt` from a repository. Any changes to `hello.txt` pushed to the `main` branch automatically update the web page thanks to a CI/CD pipeline.

---

## 🧰 Technologies

- **GitHub** — hosting code and running a CI/CD pipeline
- **AWS** — virtual server, DNS and domain name, S3 Bucket
- **Terraform** — Infrastructure as Code
- **Ansible** — setting up an environment on EC2
- **Docker + Nginx** — containerizing a web application
- **GitHub Actions** — CI/CD pipeline

---

## 📦 Project structure

```bash
. 
├── .github/
│ ├── workflows/
│ │ ├── ci.yml # CI: build, test, publish image
│ │ └── cd.yml # CD: deploy to EC2
├── docker/
│ ├── docker-compose.yaml # Start Nginx container
│ ├── default.conf # Nginx configuration with SSL
│ └── Dockerfile # Build image with hello.txt
├── terraform/
│ ├── main.tf # EC2, Route53, SG, key
│ ├── variables.tf # Terraform parameters
│ ├── outputs.tf # Public IP
│ └── versions.tf # Backend and providers
├── ansible/
│ ├── install_docker.yaml # Install Docker on EC2
│ └── inventory.ini # Inventory with host
├── index.html # HTML shell
├── hello.txt # Page content
└── README.md
```

---

## ☁️ Infrastructure as Code (Terraform)

- Created by:
- EC2 instance (Ubuntu, `t2.micro`)
- Security Group with permissions on ports 22, 80, 443
- AWS Key Pair for SSH
- DNS record in Route 53 (subdomain `test.artembobrov.click`)
- Used by:
- `backend` on S3 + DynamoDB for storing `tfstate`

---

## 🔧 Server configuration (Ansible)

- Installed by:
- `docker-ce`, `docker-compose-plugin`, `buildx-plugin`
- Configured Docker CE repository
- Restarted Docker after installation
- Used inventory `inventory.ini` with EC2 address

---

## 🐳 Docker and Nginx

- Container based on `nginx:latest`
- In `Dockerfile`:
- Copies `hello.txt` and `index.html`
- Adds self-signed SSL certificate
- Configuration `default.conf` points to HTTPS and returns `index.html`
- Optional: Let's Encrypt support is possible manually

---

## 🔁 CI/CD (GitHub Actions)

### CI (`ci.yml`)

- Builds Docker image
- Runs curl test over HTTPS
- Saves `.tar` image (optionally uploads to S3)

### CD (`cd.yml`)

- Runs after CI
- Installs SSH key
- Copies Dockerfile, docker-compose, configs, hello.txt, index.html to EC2
- Runs `docker-compose up --force-recreate --build` on the server

---

## 🌐 Result

- The site is available at: `https://test.artembobrov.click`
- Whenever `hello.txt` is changed and open pull request to `main` is made:
- CI builds the image
- CD deploys new content to EC2
- The content on the site is updated automatically

---

## ✅ Task requirements met

- [x] Infrastructure is created automatically (Terraform)
- [x] EC2 is provisioned automatically (Ansible)
- [x] CI/CD pipeline is running and updating content
- [x] Public URL is available
- [x] Changes to `hello.txt` are reflected automatically

## 📦 TODO / Possible improvements
- Deployment via ECS or EKS
- Use HTML templating via or `Jinja2`
- 🔐 Configure Let's Encrypt instead of self-signed certificate to eliminate browser warnings
