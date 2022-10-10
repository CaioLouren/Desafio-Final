({
    CadastroDeSedeHelper: function (component, event) {
        var action = component.get('c.cadastroSede');

        action.setParams({
            nomeSede: component.get('v.nomeSede'),
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
                "message": "A Sede foi criada com sucesso."
            });
            window.location.href = `https://empathetic-bear-jdaa22-dev-ed.lightning.force.com/lightning/r/Sede__c/${url}/view`;
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
        component.set('v.nomeSede', ' ')
        component.set('v.endereco', ' ')
    }
})