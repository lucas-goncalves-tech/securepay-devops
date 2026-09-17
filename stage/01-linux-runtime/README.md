# 🛠️ Estágio 01: Linux Runtime, Processos, Redes L4 e Sinais POSIX

> **RFC-001:** Operacionalização da API de Pagamentos no Sistema Operacional Host.  
> **Objetivo Técnico:** Dominar o ciclo de vida da aplicação diretamente no Linux (variáveis de ambiente, sockets de rede e sinais do kernel) antes de empacotá-la em contêineres.

---

## 🎯 Contexto do Problema

Em ambientes corporativos, falhas de inicialização e desligamento de microsserviços frequentemente ocorrem por três causas básicas:
1. **Credenciais expostas no código:** Senhas e segredos gravados diretamente em arquivos de configuração versionados no Git.
2. **Probes cegas de inicialização:** Falta de um teste automatizado que confirme se a aplicação e suas dependências (como o banco de dados) estão realmente prontas para receber tráfego.
3. **Encerramento abrupto de processos (`kill -9`):** Interrupções forçadas que impedem a JVM de fechar conexões ativas no PostgreSQL, deixando registros inconsistentes e locks presos no banco.

Neste estágio, você vai estruturar a execução da API no Linux host, garantindo injeção limpa de variáveis de ambiente, verificação determinística de saúde e encerramento gracioso via sinais POSIX.

---

## 📋 Critérios de Aceite

> Cada item abaixo é um checkbox independente que espelha uma asserção do oráculo (`verify.py`). Abra o accordion só da task atual.

- [x] **Variáveis de Ambiente Desacopladas (`.env` e `.env.example`):**
  <details>
  <summary>ver detalhes</summary>

  - Criar o arquivo `stages-labs/spring-cloud-platform/01-linux-runtime/.env` contendo as variáveis esperadas pela aplicação (`app/ledger-service/src/main/resources/application.yml`):
    * `SPRING_DATASOURCE_URL` (ex: `jdbc:postgresql://localhost:5432/securepay_db`)
    * `SPRING_DATASOURCE_USERNAME` (ex: `postgres`)
    * `SPRING_DATASOURCE_PASSWORD` (ex: `postgres`)
    * `PORT` (ex: `8080`)
    * `JWT_SECRET` (chave de 256 bits em hexadecimal ou base64)
  - Manter o arquivo `.env` fora do versionamento e disponibilizar um `stages-labs/spring-cloud-platform/01-linux-runtime/.env.example` como modelo de referência.

  </details>

- [x] **Script de Healthcheck Automatizado (`healthcheck.sh`):**
  <details>
  <summary>ver detalhes</summary>

  - Criar o script `stages-labs/spring-cloud-platform/01-linux-runtime/healthcheck.sh` com permissão de execução (`chmod +x`).
  - Testar a escuta da porta na camada L4 (usando `nc -z`, `/dev/tcp` ou `curl`).
  - Consultar o endpoint HTTP L7 `/actuator/health` da aplicação e verificar se o status retornado é `"UP"`.
  - Retornar exit code `0` quando o serviço estiver saudável e exit code `1` quando a aplicação estiver inacessível ou com status diferente de UP.

  </details>

---

## 🚧 Fronteira de Não-Escopo

- ❌ **Proibido Cobrar:** Docker, Docker Compose, Terraform, Kubernetes, LocalStack, CI/CD.
- ✅ **Foco Exclusivo:** Processos Linux, permissões de arquivo, variáveis de ambiente no `.env`, portas locais (`ss -tulpn`), PostgreSQL no host e script de healthcheck em bash.

---

## 📚 Documentação de Referência
- [Spring Boot Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config)
- [Spring Boot Graceful Shutdown](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.graceful-shutdown)
- [Linux Signals and Traps (man 7 signal)](https://man7.org/linux/man-pages/man7/signal.7.html)

---

## ⚖️ Validação Mecânica (Oráculo)
Para validar os critérios deste estágio, execute no terminal:
```bash
python3 stages-labs/spring-cloud-platform/01-linux-runtime/verify.py
```
O estágio é considerado concluído quando todas as asserções retornarem `PASS` e o Exit Code for `0`.
