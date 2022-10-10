public with sharing class Venda {
    @AuraEnabled
    public static String venda(String veiculo, Decimal quantidade, Decimal desconto, String cliente, String sede) {
        
            Loca_o__c novoCadastro = new Loca_o__c();
            Ve_culo__c vei  = [SELECT Id, Pre_o_de_Venda__c,Estoque_Venda__c FROM  Ve_culo__c WHERE Id =: veiculo ];
            Cliente__c clientes = [SELECT Id, Total_gasto_em_loca_es__c, Loca_o__c FROM Cliente__c  WHERE Id =: cliente ];
            Sede__c faturamento = [SELECT Id, Faturamento__c FROM Sede__c WHERE Id =: sede];


            novoCadastro.recordTypeId = '0128c000001bNgwAAE';
            novoCadastro.Ve_culo_Negocio__c = veiculo;
            novoCadastro.Quantidade_de_Veiculos__c = quantidade;
            novoCadastro.Cliente_Negocio__c = cliente;
            novoCadastro.Sede_Negocio__c = sede;
            novoCadastro.Valor_da_Venda__c = vei.Pre_o_de_Venda__c * quantidade;
            novoCadastro.Desconto__c = desconto;
           
            if(vei.Estoque_Venda__c > 0 && quantidade <= vei.Estoque_Venda__c ){
                if (quantidade > 1 && desconto == 0 || desconto == null) {
                    vei.Estoque_Venda__c -= quantidade;
                    faturamento.Faturamento__c += novoCadastro.Valor_da_Venda__c;
                    update vei;
                    update faturamento; 
                }
                
                if(quantidade == 1 && clientes.Total_gasto_em_loca_es__c > 0 && desconto > 0 ){
                    if (desconto <= clientes.Total_gasto_em_loca_es__c) {
                    if (novoCadastro.Valor_da_Venda__c - desconto > (novoCadastro.Valor_da_Venda__c * 0.2) - novoCadastro.Valor_da_Venda__c) {
                           novoCadastro.Valor_da_Venda__c -= desconto;
                           clientes.Total_gasto_em_loca_es__c -= desconto;
                           vei.Estoque_Venda__c -= quantidade;
                           faturamento.Faturamento__c += novoCadastro.Valor_da_Venda__c;
                           
                           update faturamento;
                           update clientes;
                           update vei;
                        }else {
                            throw new AuraHandledException('ValorDescontoAcimadoVeículo');
                        }
                    }else {
                        throw new AuraHandledException('DescontoMaiorQueOTotal');
                    }
                }else if (desconto >= clientes.Total_gasto_em_loca_es__c) {
                    throw new AuraHandledException('DescontoMaiorQueOTotalIndisponivel');
                }
                else if (quantidade > 1 && desconto > 0){
                    throw new AuraHandledException('DescontoVendaUmVeículo');
                }
                
            }
            else{
                throw new AuraHandledException('MaiorQueUmVeiculo');
            }
            update clientes;
            insert novoCadastro;
            return novoCadastro.Id;
            
    }
}