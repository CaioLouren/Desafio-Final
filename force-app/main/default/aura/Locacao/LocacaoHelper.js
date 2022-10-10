({
    LocacaoHelper: function (component, event) {
        var action = component.get('c.locacao');

        action.setParams({
            veiculo: component.get('v.veiculo'),
            cliente: component.get('v.cliente'),
            data: component.get('v.data'),
            sede: component.get('v.sede'),
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
        console.log(error);

        if (state == 'SUCCESS') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Sucesso!",
                "type": "success",
                "message": "A Locação foi feita com sucesso."
            });
            window.location.href = `https://empathetic-bear-jdaa22-dev-ed.lightning.force.com/lightning/r/Loca_o__c/${url}/view`;
            toastEvent.fire();
        }
        else {
            let toastEvent = $A.get("e.force:showToast");
            if (error[0].message == 'VeiculoIndisponivel') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "'Verique se os Dados estão corretos ou se o Veículo está DISPONIVEL'"
                });
                toastEvent.fire();
            }
            else if (error[0].message == 'ClienteIndisponivel') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "Verique se os Dados estão corretos ou se o Cliente está DISPONIVEL"
                });
                toastEvent.fire();
            }
            else if (error[0].message == 'DataIndisponivel') {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "SÁBADO E DOMINGO É INDISPONIVEL,Tente outro dia."
                });
                toastEvent.fire();
            }
            else {
                toastEvent.setParams({
                    "title": "ERROR!",
                    "type": "error",
                    "message": "A Locação não foi feita."
                });
                toastEvent.fire();
            }
        }
    },

    limparNome: function (component) {
        component.set('v.veiculo', ' ');
        component.set('v.cliente', ' ');
        component.set('v.data', ' ');
        component.set('v.sede', ' ');
    }
})