import * as functions from 'firebase-functions';
import { GoogleAuth } from 'google-auth-library';
import * as jwt from 'jsonwebtoken';

interface WalletObjectData {
  objectSuffix: string;
  title: string;
  header: string;
  details: string;
  description: string;
  reality: string;
  image: string;
  imageText: string;
  heroImage: string;
  backgroundColor: string;
}

export const generateWalletObjectJWT = functions.https.onCall(async (data: WalletObjectData, context) => {
  const { objectSuffix, title, header, details, description, reality, image, imageText, heroImage, backgroundColor } = data;
  const issuerId: string = functions.config().wallet.issuer_id;
  const classSuffix: string = functions.config().wallet.class_suffix;
  const classId: string = `${issuerId}.${classSuffix}`;
  const objectId: string = `${issuerId}.${objectSuffix}`;

  const encodedCredentials = functions.config().wallet.credentials;
  const decodedCredentials = Buffer.from(encodedCredentials, 'base64').toString('utf8');
  const credentials =  JSON.parse(decodedCredentials);


  new GoogleAuth({
    credentials: credentials,
    scopes: ['https://www.googleapis.com/auth/wallet_object.issuer'],
  });

  const pass = {
    'id': objectId,
    'classId': `${classId}`,
    'genericType': 'GENERIC_TYPE_UNSPECIFIED',
    'logo': {
      'sourceUri': {
        'uri': 'https://firebasestorage.googleapis.com/v0/b/recyclo-game.appspot.com/o/logo%2Flogo.png?alt=media&token=69dcc8d4-3a7c-4602-be3e-bce79c37cd81',
      },
      'contentDescription': {
        'defaultValue': {
          'language': 'en-US',
          'value': 'LOGO_IMAGE_DESCRIPTION',
        },
      },
    },
    'cardTitle': {
      'defaultValue': {
        'language': 'en-US',
        'value': `${title}`,
      },
    },
    'subheader': {
      'defaultValue': {
        'language': 'en-US',
        'value': 'Product',
      },
    },
    'header': {
      'defaultValue': {
        'language': 'en-US',
        'value': `${header}`,
      },
    },
    'imageModulesData': [
      {
        'mainImage': {
          'sourceUri': {
            'uri': `${image}`,
          },
          'contentDescription': {
            'defaultValue': {
              'language': 'en-US',
              'value': `${imageText}`,
            },
          },
        },
        'id': 'banner',
      },
    ],
    'textModulesData': [
      {
        'id': 'details',
        'header': 'Details',
        'body': `${details}`,
      },
      {
        'id': 'description',
        'header': 'Description',
        'body': `${description}`,
      },
      {
        'id': 'reality',
        'header': 'Reality',
        'body': `${reality}`,
      },
    ],
    'barcode': {
      'type': 'QR_CODE',
      'value': 'Discount QR Code',
      'alternateText': 'Future discount',
    },
    'hexBackgroundColor': `${backgroundColor}`,
    'heroImage': {
      'sourceUri': {
        'uri': `${heroImage}`,
      },
      'contentDescription': {
        'defaultValue': {
          'language': 'en-US',
          'value': 'HERO_IMAGE_DESCRIPTION',
        },
      },
    },
  };

  const claims = {
    origins: ['http://localhost:3000'],
    typ: 'savetowallet',
    payload: {
      genericObjects: [pass],
    },
    iss: credentials.client_email, 
    aud: 'google',
  };

  const token: string = jwt.sign(claims, credentials.private_key, { algorithm: 'RS256' });

  return { jwt: token };
});
