public with sharing class Locacao {
    @AuraEnabled
    public static String locacao(String veiculo, String cliente, Decimal data, String sede) {
      
        Loca_o__c novoCadastro = new Loca_o__c();
        Ve_culo__c vei  = [SELECT Id, Pre_o_de_Loca_o__c,Pre_o_de_Venda__c, Quantidade_Dispon_vel_Loca_o__c FROM  Ve_culo__c WHERE Id =: veiculo ];
        Cliente__c clientes = [SELECT Id, Nome_Completo__c,Total_gasto_em_loca_es__c, Loca_o__c, DataStatusLocacao__c, Email__c FROM Cliente__c  WHERE Id =: cliente ];
        Sede__c faturamento = [SELECT Id, Faturamento__c FROM Sede__c WHERE Id =: sede];

        Date dataDevolucao = Date.today();
        Integer dataInt = Integer.valueOf(data);

        if (clientes.Loca_o__c	== 'Sem Locação'){
        
        novoCadastro.Data_de_Devolu_o__c = dataDevolucao.addDays(dataInt);
        Date myDate = novoCadastro.Data_de_Devolu_o__c;
        Integer myDOW = myDate.toStartofWeek().daysBetween(myDate);   

        if (myDOW != 0 && myDOW != 6) {
            
            novoCadastro.recordTypeId = '0128c000001bNy2AAE';
            novoCadastro.Ve_culo_Negocio__c = veiculo;
            novoCadastro.Cliente_Negocio__c = cliente;
            novoCadastro.Data__c = data;
            novoCadastro.Sede_Negocio__c = sede; 
            novoCadastro.Valor_total_da_loca_o__c = vei.Pre_o_de_Loca_o__c * data;
            novoCadastro.Desconto_Aplicado__c = 0;
            clientes.DataStatusLocacao__c = novoCadastro.Data_de_Devolu_o__c;
            clientes.Total_gasto_em_loca_es__c += novoCadastro.Valor_total_da_loca_o__c;
            clientes.Loca_o__c = 'Ativa';
            
            if(data <= 6){
                novoCadastro.Desconto_Aplicado__c = 0;
                faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
            }
            else if(data > 6 && data <= 13) {
                novoCadastro.Desconto_Aplicado__c = (novoCadastro.Valor_total_da_loca_o__c * 5)/100;
                novoCadastro.Valor_total_da_loca_o__c -= novoCadastro.Desconto_Aplicado__c;
                faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
        }
        
        else if(data > 13 && data <= 20) {
            novoCadastro.Desconto_Aplicado__c = (novoCadastro.Valor_total_da_loca_o__c * 10)/100;
            novoCadastro.Valor_total_da_loca_o__c -= novoCadastro.Desconto_Aplicado__c;
            faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
        }
        
        else if(data > 20) {
            novoCadastro.Desconto_Aplicado__c = (novoCadastro.Valor_total_da_loca_o__c * 15)/100;
            novoCadastro.Valor_total_da_loca_o__c -= novoCadastro.Desconto_Aplicado__c;
            faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
        }
        
        
        if(clientes.Total_gasto_em_loca_es__c >= vei.Pre_o_de_Venda__c * 0.2){
            List<Messaging.Email> ListaDeEmail = new List<Messaging.Email>();
            
            Messaging.SingleEmailMessage mensagem = new Messaging.SingleEmailMessage();
            String[] toAddress = new String[]{clientes.Email__c};
            mensagem.setToAddresses(toAddress);
            String emailSub = 'Olá ' + clientes.Nome_Completo__c;
            mensagem.setSubject(emailSub);
            String disName = clientes.Nome_Completo__c;
            mensagem.setSenderDisplayName(disName);
            
            String content = 'Olá ' + clientes.Nome_Completo__c + ',<br/><br/>'+
            'Queremos agradecer por todas as suas locações '+
            'aqui conosco na Rodlers Concessionária e Locadora. '+
            'Por todas as locações que você fez durante esse tempo, estamos '+
            'oferecendo um desconto de 20% na sua próxima compra!'+' <br/><br/>'+
            'Sim, você leu isso corretamente!'+
            'Na sua próxima compra em qualquer uma de nossas sedes, você poderá aplicar um' +
            'desconto de 20% no valor de um veículo! Não perca essa chance!'+' <br/><br/>'+'Atenciosamente,'+
            'Rodler’s Concessionária e Locadora.';
            
            mensagem.setHtmlBody(content);
            ListaDeEmail.add(mensagem);
            
            Messaging.sendEmail(ListaDeEmail);
        }
        
        if(vei.Quantidade_Dispon_vel_Loca_o__c > 0){
            vei.Quantidade_Dispon_vel_Loca_o__c -= 1;
            update vei;
        }
        
        else{
            throw new AuraHandledException('VeiculoIndisponivel');
        }
        }else {
            throw new AuraHandledException('DataIndisponivel');
        }
    }
    else{
        throw new AuraHandledException('ClienteIndisponivel');
    }
    

        if (clientes.DataStatusLocacao__c >= dataDevolucao && clientes.Loca_o__c == 'Ativa' ) {
        
        novoCadastro.Data_de_Devolu_o__c = dataDevolucao.addDays(dataInt);
        Date myDate = novoCadastro.Data_de_Devolu_o__c;
        Integer myDOW = myDate.toStartofWeek().daysBetween(myDate);   
        
        if (myDOW != 0 && myDOW != 6) {  
    
            novoCadastro.recordTypeId = '0128c000001bNy2AAE';
            novoCadastro.Ve_culo_Negocio__c = veiculo;
            novoCadastro.Cliente_Negocio__c = cliente;
            novoCadastro.Data__c = data;
            novoCadastro.Sede_Negocio__c = sede; 
            novoCadastro.Valor_total_da_loca_o__c = vei.Pre_o_de_Loca_o__c * data;
            novoCadastro.Desconto_Aplicado__c = 0;
            clientes.DataStatusLocacao__c = novoCadastro.Data_de_Devolu_o__c;
            clientes.Total_gasto_em_loca_es__c = novoCadastro.Valor_total_da_loca_o__c;
            if (Date.today() < clientes.DataStatusLocacao__c) {
                clientes.Loca_o__c = 'Ativa';
            }
            else if(clientes.DataStatusLocacao__c <= Date.today()) {
                clientes.Loca_o__c = 'Sem Locação';
            }
            
            if(data <= 6){
                novoCadastro.Desconto_Aplicado__c = 0;
                faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
            }
            else if(data > 6 && data <= 13) {
                novoCadastro.Desconto_Aplicado__c = (novoCadastro.Valor_total_da_loca_o__c * 5)/100;
                novoCadastro.Valor_total_da_loca_o__c -= novoCadastro.Desconto_Aplicado__c;
                faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
            }
            
            else if(data > 13 && data <= 20) {
            novoCadastro.Desconto_Aplicado__c = (novoCadastro.Valor_total_da_loca_o__c * 10)/100;
            novoCadastro.Valor_total_da_loca_o__c -= novoCadastro.Desconto_Aplicado__c;
            faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
        }
        
        else if(data > 20) {
            novoCadastro.Desconto_Aplicado__c = (novoCadastro.Valor_total_da_loca_o__c * 15)/100;
            novoCadastro.Valor_total_da_loca_o__c -= novoCadastro.Desconto_Aplicado__c;
            faturamento.Faturamento__c += novoCadastro.Valor_total_da_loca_o__c;
        }
        
        if(clientes.Total_gasto_em_loca_es__c >= vei.Pre_o_de_Venda__c * 0.2){
            List<Messaging.Email> ListaDeEmail = new List<Messaging.Email>();
            
            Messaging.SingleEmailMessage mensagem = new Messaging.SingleEmailMessage();
            String[] toAddress = new String[]{clientes.Email__c};
            mensagem.setToAddresses(toAddress);
            String emailSub = 'Olá ' + clientes.Nome_Completo__c;
            mensagem.setSubject(emailSub);
            String disName = clientes.Nome_Completo__c;
            mensagem.setSenderDisplayName(disName);
            
            String content = 'Olá ' + clientes.Nome_Completo__c + ',<br/><br/>'+
            'Queremos agradecer por todas as suas locações '+
            'aqui conosco na Rodlers Concessionária e Locadora. '+
            'Por todas as locações que você fez durante esse tempo, estamos '+
            'oferecendo um desconto de 20% na sua próxima compra!'+' <br/><br/>'+
            'Sim, você leu isso corretamente!'+
            'Na sua próxima compra em qualquer uma de nossas sedes, você poderá aplicar um' +
            'desconto de 20% no valor de um veículo! Não perca essa chance!'+' <br/><br/>'+'Atenciosamente, '+
            'Rodler’s Concessionária e Locadora.';
            
            mensagem.setHtmlBody(content);
            ListaDeEmail.add(mensagem);
            
            Messaging.sendEmail(ListaDeEmail);
        }
        
        if(vei.Quantidade_Dispon_vel_Loca_o__c > 0){
            vei.Quantidade_Dispon_vel_Loca_o__c -= 1;
            update vei;
        }
        else{
            throw new AuraHandledException('VeiculoIndisponivel');
        }
        
    }  else {
        throw new AuraHandledException('DataIndisponivel');
    }  
    }
    
    else{
        throw new AuraHandledException('ClienteIndisponivel');
    }
    
    update faturamento;
    update clientes;
    insert novoCadastro;
    return novoCadastro.Id;

    }    
}
