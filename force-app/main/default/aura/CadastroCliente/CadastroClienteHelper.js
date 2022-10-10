({
    CadastroDeClienteHelper: function (component, event, helper) {
        var action = component.get('c.cadastroCliente');

        action.setParams({
            nomeCompleto: component.get('v.nomeCompleto'),
            email: component.get('v.email'),
            cpf: component.get('v.cpf'),
            numeroCelular: component.get('v.numeroCelular'),
            sede: component.get('v.sede'),
            endereco: component.get('v.endereco')
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
        let url = response.getReturnValue();

        if (state == 'SUCCESS') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Sucesso!",
                "type": "success",
                "message": "O Cadastro do Veículo foi criado com sucesso."
            });
            window.location.href = `https://empathetic-bear-jdaa22-dev-ed.lightning.force.com/lightning/r/Cliente__c/${url}/view`;
            toastEvent.fire();
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "error",
                "message": "O Cadastro não foi criado."
            });
            toastEvent.fire();
        }

    },

    limparNome: function (component) {
        component.set('v.nomeCompleto', ' ')
        component.set('v.email', ' ')
        component.set('v.cpf', ' ')
        component.set('v.numeroCelular', ' ')
        component.set('v.endereco', ' ')
        component.set('v.sede', ' ')
    }
})