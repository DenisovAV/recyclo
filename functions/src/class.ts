import * as functions from 'firebase-functions';
import { GoogleAuth } from 'google-auth-library';

export const checkOrCreateWalletClass = functions.https.onRequest(async (req, res) => { 
  const issuerId: string = functions.config().wallet.issuer_id;
  const classSuffix: string = functions.config().wallet.class_suffix;
  const classId: string = `${issuerId}.${classSuffix}`;
  const encodedCredentials = functions.config().wallet.credentials;
  const decodedCredentials = Buffer.from(encodedCredentials, 'base64').toString('utf8');
  const credentials =  JSON.parse(decodedCredentials);
  
  const baseUrl = 'https://walletobjects.googleapis.com/walletobjects/v1';

  const auth = new GoogleAuth({
    credentials: credentials,
    scopes: ['https://www.googleapis.com/auth/wallet_object.issuer'],
  });

  const client = await auth.getClient();
  const url = `${baseUrl}/genericClass/${classId}`;

  try {
    const response = await client.request({ url, method: 'GET' });
    res.send(`Class already exists: ${(response as any).data.id}`);
  } catch (err: any) {
    if (err.response && err.response.status === 404) {
      const genericClass = {
        'id': classId,
        'classTemplateInfo': {
            'cardTemplateOverride': {
              'cardRowTemplateInfos': [
                {
                  'oneItem': {
                    'item': {
                      'firstValue': {
                        'fields': [
                          {
                            'fieldPath': "object.textModulesData['description']",
                          },
                        ],
                      },
                    },
                  },
                },
              ],
            },
          },
          'linksModuleData': {
            'uris': [
              {
                'uri': 'http://recyclo.dev/',
                'description': 'Recyclo Game Webite',
                'id': 'official_site',
              },
            ],
          },
        };  

      try {
        const createResponse = await client.request({
          url: `${baseUrl}/genericClass`,
          method: 'POST',
          data: genericClass,
        });
        res.send(`Class created: ${(createResponse as any).data.id}`);
      } catch (createErr) {
        console.error(createErr);
        res.status(500).send((createErr as any).message);
      }
    } else {
      console.error(err);
      res.status(500).send(err.message);
    }
  }
});
