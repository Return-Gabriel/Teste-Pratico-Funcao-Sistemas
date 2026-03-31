// =========================================================
// ADD: Variáveis globais para gerenciar os novos beneficiarios na tela
// =========================================================
var beneficiarios = [];
var indexEdicaoBeneficiario = -1;

$(document).ready(function () {

    // =========================================================
    // ADD: mascara de CPF (Cliente e beneficiario) -- 
    // =========================================================
    $('#CPF, #CPFBeneficiario').on('input', function () {
        var v = $(this).val().replace(/\D/g, ""); 
        v = v.replace(/(\d{3})(\d)/, "$1.$2");    
        v = v.replace(/(\d{3})(\d)/, "$1.$2");    
        v = v.replace(/(\d{3})(\d{1,2})$/, "$1-$2"); 
        $(this).val(v);
    });

    // =========================================================
    // ADD: "Incluir/Alterar" 
    // =========================================================
    $('#btnSalvarBeneficiario').click(function () {
        var cpfBen = $('#CPFBeneficiario').val();
        var nomeBen = $('#NomeBeneficiario').val();
        var idBen = $('#IdBeneficiarioEdicao').val();

        
        if (cpfBen.length !== 14 || nomeBen.trim() === '') {
            ModalDialog("Atenção", "Preencha o CPF corretamente e o Nome do beneficiário.");
            return;
        }

        var cpfJaExisteNaTela = beneficiarios.some(function (b, index) {
            return b.CPF === cpfBen && index !== indexEdicaoBeneficiario;
        });

        if (cpfJaExisteNaTela) {
            ModalDialog("Atenção", "Este CPF já foi adicionado para um beneficiário.");
            return;
        }

        if (indexEdicaoBeneficiario > -1) {
            beneficiarios[indexEdicaoBeneficiario].CPF = cpfBen;
            beneficiarios[indexEdicaoBeneficiario].Nome = nomeBen;
        } else {
            beneficiarios.push({ Id: idBen, CPF: cpfBen, Nome: nomeBen });
        }

        LimparFormularioBeneficiario();
        RenderizarGridBeneficiarios();
    });

    
    $('#formCadastro').submit(function (e) {
        e.preventDefault();
        $.ajax({
            url: urlPost,
            method: "POST",
            data: {
                "NOME": $(this).find("#Nome").val(),
                "CEP": $(this).find("#CEP").val(),
                "Email": $(this).find("#Email").val(),
                "Sobrenome": $(this).find("#Sobrenome").val(),
                "Nacionalidade": $(this).find("#Nacionalidade").val(),
                "Estado": $(this).find("#Estado").val(),
                "Cidade": $(this).find("#Cidade").val(),
                "Logradouro": $(this).find("#Logradouro").val(),
                "Telefone": $(this).find("#Telefone").val(),
                // ADD: campo novo
                "CPF": $(this).find("#CPF").val(),
                "Beneficiarios": beneficiarios
            },
            error:
                function (r) {
                    if (r.status == 400)
                        ModalDialog("Ocorreu um erro", r.responseJSON);
                    else if (r.status == 500)
                        ModalDialog("Ocorreu um erro", "Ocorreu um erro interno no servidor.");
                },
            success:
                function (r) {
                    ModalDialog("Sucesso!", r)
                    $("#formCadastro")[0].reset();

                    // ADD: Limpa o grid 
                    beneficiarios = [];
                    RenderizarGridBeneficiarios();
                }
        });
    })

})

// =========================================================
// ADD: Funções Auxiliares para manipular o Grid exemplo do stack overflow 
// =========================================================
function RenderizarGridBeneficiarios() {
    var tbody = $('#gridBeneficiarios tbody');
    tbody.empty();

    beneficiarios.forEach(function (ben, index) {
        var tr = '<tr>' +
            '<td>' + ben.CPF + '</td>' +
            '<td>' + ben.Nome + '</td>' +
            '<td>' +
            '<button type="button" class="btn btn-sm btn-primary" onclick="EditarBeneficiario(' + index + ')" style="margin-right: 5px;">Alterar</button>' +
            '<button type="button" class="btn btn-sm btn-danger" onclick="ExcluirBeneficiario(' + index + ')">Excluir</button>' +
            '</td>' +
            '</tr>';
        tbody.append(tr);
    });
}

function EditarBeneficiario(index) {
    var ben = beneficiarios[index];
    $('#CPFBeneficiario').val(ben.CPF);
    $('#NomeBeneficiario').val(ben.Nome);
    $('#IdBeneficiarioEdicao').val(ben.Id || 0);

    indexEdicaoBeneficiario = index;
    $('#btnSalvarBeneficiario').text('Alterar');
}

function ExcluirBeneficiario(index) {
    beneficiarios.splice(index, 1);
    RenderizarGridBeneficiarios();
}

function LimparFormularioBeneficiario() {
    $('#CPFBeneficiario').val('');
    $('#NomeBeneficiario').val('');
    $('#IdBeneficiarioEdicao').val('0');
    indexEdicaoBeneficiario = -1;
    $('#btnSalvarBeneficiario').text('Incluir');
}

function ModalDialog(titulo, texto) {
    var random = Math.random().toString().replace('.', '');
    var texto = '<div id="' + random + '" class="modal fade">                                                               ' +
        '        <div class="modal-dialog">                                                                                 ' +
        '            <div class="modal-content">                                                                            ' +
        '                <div class="modal-header">                                                                         ' +
        '                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>         ' +
        '                    <h4 class="modal-title">' + titulo + '</h4>                                                    ' +
        '                </div>                                                                                             ' +
        '                <div class="modal-body">                                                                           ' +
        '                    <p>' + texto + '</p>                                                                           ' +
        '                </div>                                                                                             ' +
        '                <div class="modal-footer">                                                                         ' +
        '                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>             ' +
        '                                                                                                                   ' +
        '                </div>                                                                                             ' +
        '            </div>' +
        '  </div>' +
        '</div> ';

    $('body').append(texto);
    $('#' + random).modal('show');
}