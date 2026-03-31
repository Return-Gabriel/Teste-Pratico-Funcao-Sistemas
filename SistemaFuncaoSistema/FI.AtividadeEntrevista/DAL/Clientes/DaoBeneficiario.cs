using FI.AtividadeEntrevista.DML;
using System.Collections.Generic;
using System.Data;

namespace FI.AtividadeEntrevista.DAL
{
    /// <summary>
    /// Classe de acesso a dados de Beneficiário
    /// </summary>
    internal class DaoBeneficiario : AcessoDados
    {
        internal void Incluir(Beneficiario beneficiario)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                new System.Data.SqlClient.SqlParameter("CPF", beneficiario.CPF),
                new System.Data.SqlClient.SqlParameter("Nome", beneficiario.Nome),
                new System.Data.SqlClient.SqlParameter("IDCLIENTE", beneficiario.IdCliente)
            };

            base.Executar("FI_SP_IncBeneficiario", parametros);
        }

        internal void Alterar(Beneficiario beneficiario)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                new System.Data.SqlClient.SqlParameter("ID", beneficiario.Id),
                new System.Data.SqlClient.SqlParameter("CPF", beneficiario.CPF),
                new System.Data.SqlClient.SqlParameter("Nome", beneficiario.Nome),
                new System.Data.SqlClient.SqlParameter("IDCLIENTE", beneficiario.IdCliente)
            };

            base.Executar("FI_SP_AltBeneficiario", parametros);
        }

        internal void Excluir(long id)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                new System.Data.SqlClient.SqlParameter("ID", id)
            };

            base.Executar("FI_SP_DelBeneficiario", parametros);
        }

        internal List<Beneficiario> Listar(long idCliente)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                new System.Data.SqlClient.SqlParameter("IDCLIENTE", idCliente)
            };

            DataSet ds = base.Consultar("FI_SP_ConsBeneficiario", parametros);
            List<Beneficiario> beneficiarios = new List<Beneficiario>();

            if (ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    beneficiarios.Add(new Beneficiario
                    {
                        Id = row.Field<long>("ID"),
                        CPF = row.Field<string>("CPF"),
                        Nome = row.Field<string>("NOME"),
                        IdCliente = row.Field<long>("IDCLIENTE")
                    });
                }
            }

            return beneficiarios;
        }

        internal bool VerificarExistencia(string CPF, long idCliente, long idBeneficiarioAtual = 0)
        {
            List<System.Data.SqlClient.SqlParameter> parametros = new List<System.Data.SqlClient.SqlParameter>
            {
                new System.Data.SqlClient.SqlParameter("CPF", CPF),
                new System.Data.SqlClient.SqlParameter("IDCLIENTE", idCliente),
                new System.Data.SqlClient.SqlParameter("ID", idBeneficiarioAtual)
            };

            DataSet ds = base.Consultar("FI_SP_VerificaBeneficiario", parametros);
            return ds.Tables[0].Rows.Count > 0;
        }
    }
}