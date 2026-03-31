## 📌 Observações sobre Padrões de Banco de Dados

Durante o desenvolvimento deste teste, optei por **manter a consistência** com o padrão de nomenclatura já existente no projeto base da Função Sistemas (tabelas e colunas em maiúsculo, procedures com o prefixo `FI_SP_`, etc.).
Acredito que adaptar-se e respeitar a arquitetura do projeto atual é uma premissa fundamental ao assumir manutenções ou evoluções de software.

No entanto, gostaria de ressaltar que, em projetos criados do zero ou na minha padronização pessoal do dia a dia, adoto convenções diferentes para garantir maior legibilidade e padronização:

* **Tabelas e Colunas:** Utilizo o padrão `snake_case` (letras minúsculas com palavras separadas por underline `_`). 
  * *Exemplo:* `tabela_clientes`, `data_nascimento`.
* **Stored Procedures:** Utilizo rigorosamente o padrão de cabeçalho de documentação (que fiz questão de aplicar nos scripts deste teste) e uma nomenclatura baseada na ação do CRUD:
  * `prc_i_nome_procedure` (Para regras de Insert)
  * `prc_s_nome_procedure` (Para regras de Select)
  * `prc_u_nome_procedure` (Para regras de Update)
  * `prc_d_nome_procedure` (Para regras de Delete)


## 🛠️ Ferramentas de Apoio e Referências
Para otimizar o tempo de desenvolvimento, focar nas regras de negócio e garantir a qualidade da entrega, utilizei as seguintes ferramentas e fontes de pesquisa:

* **Algoritmo de Validação (CPF):** A lógica matemática para validação dos dígitos verificadores na camada de negócio (BLL) foi baseada em algoritmos sólidos e amplamente testados pela comunidade de desenvolvedores em fóruns como **Stack Overflow** e **Reddit**. A decisão de utilizar uma base madura evita "reinventar a roda" e garante a confiabilidade da validação.
* **Massa de Dados para Testes:** Utilizei o portal **4Devs** (www.4devs.com.br) para gerar CPFs fictícios válidos e inválidos, garantindo uma cobertura de testes de ponta a ponta na interface e no back-end.
* **Produtividade em Banco de Dados:** Uso do **SQL Prompt (Redgate)** acoplado ao SSMS/Visual Studio para acelerar a escrita, refatoração e formatação limpa dos scripts SQL e Procedures.
* **Inteligência Artificial (Pair Programming):** Uso estratégico de assistentes de IA (**Google Gemini** e **GitHub Copilot**) para acelerar a digitação de *boilerplate code*, geração de dados estruturados e auxílio no *troubleshooting* do ambiente local.

## 💻 Tecnologias e Arquitetura
* **Back-end:** C#, ASP.NET MVC, .NET Framework.
* **Acesso a Dados:** ADO.NET puro (via `SqlConnection` e `SqlCommand` conforme o padrão do projeto), SQL Server (LocalDB).
* **Front-end:** HTML5, CSS3, JavaScript, jQuery, Bootstrap e jTable.
* **Arquitetura:** Separação estrutural em N-Camadas (MVC, BLL - Business Logic Layer, e DAL - Data Access Layer).
