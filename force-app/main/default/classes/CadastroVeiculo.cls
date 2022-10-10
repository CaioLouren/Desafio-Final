public with sharing class CadastroVeiculo {
    @AuraEnabled
    public static String cadastroVeiculo(String modelo, String marca, String nivel, Decimal estoqueVenda, Decimal estoqueLocacao, String sede, Decimal precoDeVenda, Decimal precoDeLocacao, Decimal quantidadeDisponivel){
        try {
            Ve_culo__c novoCadastro = new Ve_culo__c();
            
            novoCadastro.Modelo__c = modelo;
            novoCadastro.Marca__c = marca;
            novoCadastro.N_vel__c = nivel;
            novoCadastro.Estoque_Venda__c = estoqueVenda;
            novoCadastro.Estoque_Loca_o__c = estoqueLocacao;
            novoCadastro.Sede_de_cadastro__c = sede;
            novoCadastro.Pre_o_de_Venda__c = precoDeVenda;
            novoCadastro.Pre_o_de_Loca_o__c = precoDeLocacao;
            novoCadastro.Quantidade_Dispon_vel_Loca_o__c = quantidadeDisponivel;
            
            if (novoCadastro.N_vel__c == 'Economia') {
                novoCadastro.Pre_o_de_Venda__c = 50 * 1000;
            }
            else if (novoCadastro.N_vel__c == 'Conforto') {
                novoCadastro.Pre_o_de_Venda__c = 100 * 1000;
            }
            else if (novoCadastro.N_vel__c == 'Premium') {
                novoCadastro.Pre_o_de_Venda__c = 150 * 1000;
            }

            if (novoCadastro.N_vel__c == 'Economia') {
                novoCadastro.Pre_o_de_Loca_o__c = 50;
            }
            else if (novoCadastro.N_vel__c == 'Conforto') {
                novoCadastro.Pre_o_de_Loca_o__c = 100;
            }
            else if (novoCadastro.N_vel__c == 'Premium') {
                novoCadastro.Pre_o_de_Loca_o__c = 150;
            }

            novoCadastro.Quantidade_Dispon_vel_Loca_o__c = novoCadastro.Estoque_Loca_o__c;

            insert novoCadastro;
            return novoCadastro.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
}

}