const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.enviarMensagem = functions.https.onRequest((req, res) => {
  const mensagem = {
    notification: {
      title: 'Teste do Firebase Cloud Messaging',
      body: 'Esta é uma mensagem de teste do Firebase Cloud Messaging'
    },
    token: 'dI6-jVzLQfeyZa4HzvgmGZ:APA91bE-DfXYet1w6iDs3EC1T3UYndtX85cqQkKJy_gwM_gJm_S1lfYXD8VYXx5GnESl5-EscfvBFOhOBI8nu5u3lGK-XndQmYFgoFCx7v65cE5Qi7WGeP09YeXnXSpkR5tqMv9y-CVr'
  };
  
  admin.messaging().send(mensagem)
    .then((response) => {
      console.log('Mensagem enviada com sucesso:', response);
      res.status(200).send('Mensagem enviada com sucesso!');
    })
    .catch((error) => {
      console.log('Erro ao enviar a mensagem:', error);
      res.status(500).send('Erro ao enviar a mensagem.');
    });
});