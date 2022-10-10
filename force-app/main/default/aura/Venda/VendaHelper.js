({
    VendaHelper: function (component, event) {
        var action = component.get('c.venda');

        action.setParams({
            veiculo: component.get('v.veiculo'),
            quantidade: component.get('v.quantidade'),
            cliente: component.get('v.cliente'),
            sede: component.get('v.sede'),
            desconto: component.get('v.desconto')
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            console.log('Voltamos do back-end', state);

            this.showToast(response);
            this.limparNome(component);
        });

        $A.enqueueAction(action);
    },

    showToast: function (response) {
        let state = response.getState();
        let error = response.getError();
        let url = response.getReturnValue();
        console.log(error)

        if (state == 'SUCCESS') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Sucesso!",
                "type": "success",
                "message": "A Venda foi feita com sucesso."
            });
            window.location.href = `https://empathetic-bear-jdaa22-dev-ed.lightning.force.com/lightning/r/Loca_o__c/${url}/view`;
            toastEvent.fire();
        }

        else {
            let toastEvent = $A.get("e.force:showToast");
            if (error[0].message == 'ValorDescontoAcimadoVeículo') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "O valor do Desconto é maior do que 20% Do Veículo."
                });
                toastEvent.fire();
            }
            else if (error[0].message == 'DescontoMaiorQueOTotal') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "O cliente não tem crédito para desconto."
                });
                toastEvent.fire();
            }
            else if (error[0].message == 'DescontoMaiorQueOTotalIndisponivel') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "O Desconto é maior do que o total gasto do cliente, verifique."
                });
                toastEvent.fire();
            }
            else if (error[0].message == 'DescontoVendaUmVeículo') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "O desconto só pode ser aplicado na venda de um veículo."
                });
                toastEvent.fire();
            }
            else if (error[0].message == 'MaiorQueUmVeiculo') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "o Veículo está Indisponivel, Quantidade maior que o estoque."
                });
                toastEvent.fire();
            }
            else {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "A Venda não foi feita."
                });
                toastEvent.fire();
            }
        }
    },

    limparNome: function (component) {
        component.set('v.veiculo', ' ');
        component.set('v.cliente', ' ');
        component.set('v.sede', ' ');
    }
})