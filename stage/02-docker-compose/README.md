# 🐳 Estágio 02: Conteinerização Profissional e Docker Compose

> **RFC-002:** Empacotamento Otimizado de Imagem e Orquestração com Verificação de Saúde.  
> **Objetivo Técnico:** Construir imagens Docker enxutas, seguras (execução non-root) e orquestrar serviços com inicialização dependente de healthcheck real no banco de dados.

---

## 🎯 Contexto do Problema

Em ambientes corporativos de contêineres, três problemas recorrentes comprometem a segurança e a estabilidade das aplicações:
1. **Imagens inchadas (> 600 MB):** Incluir ferramentas de build (Maven, compiladores JDK completos e código-fonte) na imagem final enviada para produção, aumentando o tempo de transferência e a superfície de ataque.
2. **Execução como Root (UID 0):** Rodar o processo da aplicação como superusuário dentro do contêiner, permitindo que uma vulnerabilidade na aplicação (como Remote Code Execution) comprometa o nó hospedeiro.
3. **Falhas de inicialização por dependência cega:** Subir a API antes que o PostgreSQL tenha inicializado completamente o socket de rede, gerando erros imediatos de conexão no pool HikariCP.

Neste estágio, você vai criar um `Dockerfile` multi-stage corporativo e um arquivo `docker-compose.yml` resiliente.

---

## 📋 Critérios de Aceite

> Cada item abaixo é um checkbox independente que espelha uma asserção do oráculo (`verify.py`). Abra o accordion só da task atual.

- [x] **Dockerfile Multi-Stage (`app/ledger-service/Dockerfile`):**
  <details>
  <summary>ver detalhes</summary>

  - **Estágio de Build (`builder`):** Utilizar imagem base com JDK 21 para compilar o código e gerar o arquivo `.jar`.
  - **Estágio de Runtime (`runtime`):** Utilizar imagem base minimalista com JRE (ex: `eclipse-temurin:21-jre-alpine`). Copiar apenas o `.jar` gerado no primeiro estágio.
  - **Execução Não-Root:** Criar um grupo e usuário dedicados no sistema (ex: `addgroup -S spring && adduser -S spring -G spring`) e declarar a diretiva `USER spring`.
  - **Tamanho Limite da Imagem:** A imagem final deve ter menos de 220 MB.
  - **Contexto de Build Otimizado (`.dockerignore`):** Criar `app/ledger-service/.dockerignore` excluindo diretórios desnecessários (`target/`, `.git/`, `.env`).

  </details>

- [x] **Orquestração Declarativa (`stages-labs/spring-cloud-platform/02-docker-compose/docker-compose.yml`):**
  <details>
  <summary>ver detalhes</summary>

  - **Serviço `postgres`:**
    * Imagem `postgres:16-alpine`.
    * Volume nomeado persistindo `/var/lib/postgresql/data`.
    * Bloco `healthcheck` ativo testando a prontidão do banco via `pg_isready -U postgres`.
  - **Serviço `ledger-service` (ou `payment-service`):**
    * Contexto de build apontando para `../../app/ledger-service`.
    * Variáveis de ambiente configurando a URL do banco para `jdbc:postgresql://postgres:5432/securepay_db`.
    * Bloco de dependência condicional:
      ```yaml
      depends_on:
        postgres:
          condition: service_healthy
      ```

  </details>

- [x] **Validação de Execução no Terminal:**
  <details>
  <summary>ver detalhes</summary>

  - Subir a pilha de serviços com `docker compose up -d`.
  - Verificar via `docker compose ps` que ambos os serviços atingiram o estado `healthy` e permanecem operacionais.

  </details>

- [x] **Encerramento Gracioso com Sinal SIGTERM (`docker compose stop`):**
  <details>
  <summary>ver detalhes</summary>

  - Executar `docker compose stop ledger-service` (o runtime do Docker propaga o sinal POSIX `SIGTERM` / `kill -15` para o PID 1 do contêiner).
  - Inspecionar os logs (`docker compose logs ledger-service`) e confirmar que o Spring Boot interceptou o sinal e o pool HikariCP concluiu o fechamento ordenado das conexões antes do encerramento do processo.

  </details>

---

## 🚧 Fronteira de Não-Escopo

- ❌ **Proibido Cobrar:** Terraform, Kubernetes/Helm, LocalStack AWS, AWS ECS/EKS, CI/CD remoto.
- ✅ **Foco Exclusivo:** Multi-stage `Dockerfile`, redução de camada e imagem enxuta Alpine, usuário sem privilégios (`USER spring`), `docker-compose.yml` com ordenação `condition: service_healthy` e persistência de volume.

---

## 📚 Documentação de Referência
- [Docker Multi-stage Builds Best Practices](https://docs.docker.com/build/building/multi-stage/)
- [Compose Specification: depends_on](https://docs.docker.com/compose/compose-file/05-services/#depends_on)
- [Spring Boot in Docker (Official Guide)](https://spring.io/guides/gs/spring-boot-docker/)

---

## ⚖️ Validação Mecânica (Oráculo)
Para validar os critérios deste estágio, execute no terminal:
```bash
python3 stages-labs/spring-cloud-platform/02-docker-compose/verify.py
```
O estágio é considerado concluído quando todas as asserções retornarem `PASS` e o Exit Code for `0`.
