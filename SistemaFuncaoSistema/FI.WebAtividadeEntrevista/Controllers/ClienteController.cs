using FI.AtividadeEntrevista.BLL;
using WebAtividadeEntrevista.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FI.AtividadeEntrevista.DML;

namespace WebAtividadeEntrevista.Controllers
{
    public class ClienteController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Incluir()
        {
            return View();
        }

        [HttpPost]
        public JsonResult Incluir(ClienteModel model)
        {
            BoCliente bo = new BoCliente();

            if (!this.ModelState.IsValid)
            {
                List<string> erros = (from item in ModelState.Values
                                      from error in item.Errors
                                      select error.ErrorMessage).ToList();

                Response.StatusCode = 400;
                return Json(string.Join(Environment.NewLine, erros));
            }
            else
            {
                // =========================================================
                // ADD: Validação do CPF 
                // =========================================================
                if (!bo.ValidarCPF(model.CPF))
                {
                    Response.StatusCode = 400;
                    return Json("CPF inválido.");
                }

                if (bo.VerificarExistencia(model.CPF))
                {
                    Response.StatusCode = 400;
                    return Json("CPF já cadastrado.");
                }

                model.Id = bo.Incluir(new Cliente()
                {
                    CEP = model.CEP,
                    Cidade = model.Cidade,
                    Email = model.Email,
                    Estado = model.Estado,
                    Logradouro = model.Logradouro,
                    Nacionalidade = model.Nacionalidade,
                    Nome = model.Nome,
                    Sobrenome = model.Sobrenome,
                    Telefone = model.Telefone,
                    CPF = model.CPF 
                });

                if (model.Beneficiarios != null && model.Beneficiarios.Any())
                {
                    BoBeneficiario boBen = new BoBeneficiario();
                    foreach (var ben in model.Beneficiarios)
                    {
                        boBen.Incluir(new Beneficiario()
                        {
                            CPF = ben.CPF,
                            Nome = ben.Nome,
                            IdCliente = model.Id 
                        });
                    }
                }

                return Json("Cadastro efetuado com sucesso");
            }
        }

        [HttpPost]
        public JsonResult Alterar(ClienteModel model)
        {
            BoCliente bo = new BoCliente();

            if (!this.ModelState.IsValid)
            {
                List<string> erros = (from item in ModelState.Values
                                      from error in item.Errors
                                      select error.ErrorMessage).ToList();

                Response.StatusCode = 400;
                return Json(string.Join(Environment.NewLine, erros));
            }
            else
            {
                if (!bo.ValidarCPF(model.CPF))
                {
                    Response.StatusCode = 400;
                    return Json("CPF inválido.");
                }

              
                Cliente clienteAtual = bo.Consultar(model.Id);
                if (clienteAtual.CPF != model.CPF && bo.VerificarExistencia(model.CPF))
                {
                    Response.StatusCode = 400;
                    return Json("O CPF informado já pertence a outro cliente cadastrado.");
                }

                bo.Alterar(new Cliente()
                {
                    Id = model.Id,
                    CEP = model.CEP,
                    Cidade = model.Cidade,
                    Email = model.Email,
                    Estado = model.Estado,
                    Logradouro = model.Logradouro,
                    Nacionalidade = model.Nacionalidade,
                    Nome = model.Nome,
                    Sobrenome = model.Sobrenome,
                    Telefone = model.Telefone,
                    CPF = model.CPF // ADD
                });

                
                BoBeneficiario boBen = new BoBeneficiario();
                List<Beneficiario> beneficiariosAtuaisNoBanco = boBen.Listar(model.Id);

                if (beneficiariosAtuaisNoBanco != null)
                {
                    var idsVindosDaTela = model.Beneficiarios?.Select(b => b.Id).ToList() ?? new List<long>();
                    foreach (var bBanco in beneficiariosAtuaisNoBanco)
                    {
                        if (!idsVindosDaTela.Contains(bBanco.Id))
                        {
                            boBen.Excluir(bBanco.Id);
                        }
                    }
                }

                if (model.Beneficiarios != null)
                {
                    foreach (var ben in model.Beneficiarios)
                    {
                        if (ben.Id == 0)
                        {
                            boBen.Incluir(new Beneficiario() { CPF = ben.CPF, Nome = ben.Nome, IdCliente = model.Id });
                        }
                        else
                        {
                            boBen.Alterar(new Beneficiario() { Id = ben.Id, CPF = ben.CPF, Nome = ben.Nome, IdCliente = model.Id });
                        }
                    }
                }

                return Json("Cadastro alterado com sucesso");
            }
        }

        [HttpGet]
        public ActionResult Alterar(long id)
        {
            BoCliente bo = new BoCliente();
            Cliente cliente = bo.Consultar(id);
            Models.ClienteModel model = null;

            if (cliente != null)
            {
                
                BoBeneficiario boBen = new BoBeneficiario();
                var beneficiariosDoBanco = boBen.Listar(cliente.Id);

                model = new ClienteModel()
                {
                    Id = cliente.Id,
                    CEP = cliente.CEP,
                    Cidade = cliente.Cidade,
                    Email = cliente.Email,
                    Estado = cliente.Estado,
                    Logradouro = cliente.Logradouro,
                    Nacionalidade = cliente.Nacionalidade,
                    Nome = cliente.Nome,
                    Sobrenome = cliente.Sobrenome,
                    Telefone = cliente.Telefone,
                    CPF = cliente.CPF, // ADD

                    Beneficiarios = beneficiariosDoBanco.Select(b => new BeneficiarioModel()
                    {
                        Id = b.Id,
                        CPF = b.CPF,
                        Nome = b.Nome,
                        IdCliente = b.IdCliente
                    }).ToList()
                };
            }

            return View(model);
        }

        [HttpPost]
        public JsonResult ClienteList(int jtStartIndex = 0, int jtPageSize = 0, string jtSorting = null)
        {
            try
            {
                int qtd = 0;
                string campo = string.Empty;
                string crescente = string.Empty;
                string[] array = jtSorting.Split(' ');

                if (array.Length > 0)
                    campo = array[0];

                if (array.Length > 1)
                    crescente = array[1];

                List<Cliente> clientes = new BoCliente().Pesquisa(jtStartIndex, jtPageSize, campo, crescente.Equals("ASC", StringComparison.InvariantCultureIgnoreCase), out qtd);

                return Json(new { Result = "OK", Records = clientes, TotalRecordCount = qtd });
            }
            catch (Exception ex)
            {
                return Json(new { Result = "ERROR", Message = ex.Message });
            }
        }
    }
}