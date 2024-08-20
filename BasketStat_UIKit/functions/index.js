// /**
//  * Import function triggers from their respective submodules:
//  *
//  * const {onCall} = require("firebase-functions/v2/https");
//  * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
//  *
//  * See a full list of supported triggers at https://firebase.google.com/docs/functions
//  */

// // const {onRequest} = require("firebase-functions/v2/https");
// // const logger = require("firebase-functions/logger");

// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

// // // Set up Algolia
// const {default: algoliasearch} = require("algoliasearch");
// const algoliaClient = algoliasearch(
//     functions.config().algolia.appid,
//     functions.config().algolia.apikey,
// );
// const indexName = "BasketStat";
// const collectionIndex = algoliaClient.initIndex(indexName);

// Create a HTTP request cloud functions
// exports.sendCollectionToAlgolia = functions
//     .region("asia-northeast2")
//     .https.onRequest(async (request, response) => {
//       const firestore = admin.firestore();
//       const algoliaRecords = [];
//       const snapshot = await firestore
//           .collection("BasketStat_Player").get();
//       snapshot.forEach((doc) => {
//         const document = doc.data();
//         const record = {
//           objectID: doc.id,
//           nickname: document.nickname,
//           tall: document.tall,
//           position: document.position,
//           weight: document.weight,
//           profileImageUrl: document.profileImageUrl,
//         };

//         algoliaRecords.push(record);
//       });

//       // After all records are created, save them to Algolia
//       collectionIndex.saveObjects(algoliaRecords, (_error, content) => {
//         response.status(200)
//             .send("COLLECTION was indexed to Algolia successfully.");
//       });
//     });
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started
// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// // Set up Algolia
const {default: algoliasearch} = require("algoliasearch");
const algoliaClient = algoliasearch(
    functions.config().algolia.appid,
    functions.config().algolia.apikey,
);
const indexName = "BasketStat";
const collectionIndex = algoliaClient.initIndex(indexName);

const indexName1 = "BasketStat_Team";
const collectionIndex1 = algoliaClient.initIndex(indexName1);


// Firestore 문서가 생성될 때 Algolia에 추가

exports.collectionOnCreate = functions
    .region("asia-northeast2")
    .firestore.document("BasketStat_Player/{documentId}")
    .onCreate(async (snapshot, context) => {
      await saveDocumentInAlgolia(snapshot);
    });

const saveDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        nickname: data.nickname,
        tall: data.tall,
        position: data.position,
        weight: data.weight,
        profileImageUrl: data.profileImageUrl,
      };
      collectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

exports.ticcleOnUpdate = functions
    .region("asia-northeast2")
    .firestore.document("BasketStat_Player/{documentId}")
    .onUpdate(async (change, context) => {
      await updateDocumentInAlgolia(context.params.recordId, change);
    });


const updateDocumentInAlgolia = async (objectID, change) => {
  const before = change.before.data();
  const after = change.after.data();
  if (before && after) {
    const record = {objectID: objectID};
    let flag = false;
    if (before.title != after.title) {
      record.title = after.title;
      flag = true;
    }
    if (before.content != after.content) {
      record.content = after.content;
      flag = true;
    }

    if (flag) {
      // update
      collectionIndex.partialUpdateObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};


// Firestore 문서가 삭제될 때 Algolia에서 삭제
exports.ticcleOnDelete = functions
    .region("asia-northeast2")
    .firestore.document("BasketStat_Player/{documentId}")
    .onDelete(async (snapshot, context) => {
      await deleteDocumentInAlgolia(snapshot);
    });

const deleteDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    collectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};


/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

// // // Set up Algolia
// const {default: algoliasearch} = require("algoliasearch");
// const algoliaClient = algoliasearch(
//     functions.config().algolia.appid,
//     functions.config().algolia.apikey,
// );
// const indexName = "BasketStat";
// const collectionIndex = algoliaClient.initIndex(indexName);

// const indexName1 = "BasketStat_Team";
// const collectionIndex1 = algoliaClient.initIndex(indexName1);


// Create a HTTP request cloud functions
// exports.sendCollectionToAlgolia = functions
//     .region("asia-northeast2")
//     .https.onRequest(async (request, response) => {
//       const firestore = admin.firestore();
//       const algoliaRecords = [];
//       const snapshot = await firestore
//           .collection("BasketStat_Player").get();
//       snapshot.forEach((doc) => {
//         const document = doc.data();
//         const record = {
//           objectID: doc.id,
//           nickname: document.nickname,
//           tall: document.tall,
//           position: document.position,
//           weight: document.weight,
//           profileImageUrl: document.profileImageUrl,
//         };

//         algoliaRecords.push(record);
//       });

//       // After all records are created, save them to Algolia
//       collectionIndex.saveObjects(algoliaRecords, (_error, content) => {
//         response.status(200)
//             .send("COLLECTION was indexed to Algolia successfully.");
//       });
//     });
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started
// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


// Firestore 문서가 생성될 때 Algolia에 추가

exports.teamCollectionOnCreate = functions
    .region("asia-northeast2")
    .firestore.document("BasketStat_Team/{documentId}")
    .onCreate(async (snapshot, context) => {
      await saveDocumentInAlgoliaTeam(snapshot);
    });

const saveDocumentInAlgoliaTeam = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        test: data.test,
      };
      collectionIndex1.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};


exports.teamTiccleOnUpdate = functions
    .region("asia-northeast2")
    .firestore.document("BasketStat_Team/{documentId}")
    .onUpdate(async (change, context) => {
      await updateDocumentInAlgoliaTeam(context.params.recordId, change);
    });


const updateDocumentInAlgoliaTeam = async (objectID, change) => {
  const before = change.before.data();
  const after = change.after.data();
  if (before && after) {
    const record = {objectID: objectID};
    let flag = false;
    if (before.title != after.title) {
      record.title = after.title;
      flag = true;
    }
    if (before.content != after.content) {
      record.content = after.content;
      flag = true;
    }

    if (flag) {
      // update
      collectionIndex1.partialUpdateObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};


// Firestore 문서가 삭제될 때 Algolia에서 삭제
exports.teamTiccleOnDelete = functions
    .region("asia-northeast2")
    .firestore.document("BasketStat_Team/{documentId}")
    .onDelete(async (snapshot, context) => {
      await deleteDocumentInAlgoliaTeam(snapshot);
    });

const deleteDocumentInAlgoliaTeam = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    collectionIndex1.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};


