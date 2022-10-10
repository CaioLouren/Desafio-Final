public with sharing class CadastroCliente {
    @AuraEnabled
    public static String cadastroCliente(String nomeCompleto, String email, String cpf, String numeroCelular,String sede,  String endereco){
        try {
            
            Cliente__c novoCadastro = new Cliente__c();
            
            novoCadastro.Nome_Completo__c = nomeCompleto;
            novoCadastro.Email__c = email;
            novoCadastro.N_mero_de_CPF__c = cpf;
            novoCadastro.N_mero_de_Celular__c = numeroCelular;
            novoCadastro.Sede_Cliente__c = sede;
            novoCadastro.Endere_o_do_Cliente__c = endereco;
            novoCadastro.Quantadidade_de_Descontos__c = 0;
            novoCadastro.Total_gasto_em_loca_es__c = 0;
            novoCadastro.Loca_o__c	= 'Sem Locação';
            
            insert novoCadastro;

            Sede__c atualizar = [SELECT Id, Clientes_Cadastrados__c FROM  Sede__c WHERE Id =: sede ];

            atualizar.Clientes_Cadastrados__c += 1 ;

            update atualizar;
            return novoCadastro.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
}

}