({
    CadastroDeVeiculoHelper: function (component, event) {
        var action = component.get('c.cadastroVeiculo');

        action.setParams({
            modelo: component.get('v.modelo'),
            marca: component.get('v.marca'),
            nivel: component.get('v.nivel'),
            sede: component.get('v.sede'),
            estoqueVenda: component.get('v.estoqueVenda'),
            estoqueLocacao: component.get('v.estoqueLocacao'),
            precoDeVenda: component.get('v.precoDeVenda'),
            precoDeLocacao: component.get('v.precoDeLocacao'),
            quantidadeDisponivel: component.get('v.quantidadeDisponivel')
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
            window.location.href = `https://empathetic-bear-jdaa22-dev-ed.lightning.force.com/lightning/r/Ve_culo__c/${url}/view`;
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
        component.set('v.modelo', ' ')
        component.set('v.marca', ' ')
        component.set('v.nivel', ' ')
        component.set('v.estoqueVenda', ' ')
        component.set('v.estoqueLocacao', ' ')
    }

})