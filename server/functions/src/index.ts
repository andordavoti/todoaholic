import * as functions from "firebase-functions";
import * as firebaseAdmin from "firebase-admin";
import PromisePool from "es6-promise-pool";

firebaseAdmin.initializeApp();

// Maximum concurrent account deletions.
const MAX_CONCURRENT = 3;

/**
 * Run every sunday at midnight, to cleanup the users.
 * Deletion of user data is handled by the Remove User Data extension.
 * Manually run the task here https://console.cloud.google.com/cloudscheduler
 */
exports.accountcleanup = functions
  .region("europe-west1")
  .pubsub.schedule("every sunday 00:00")
  .onRun(async () => {
    // Fetch all user details.
    const inactiveUsers = await getInactiveUsers();
    // Use a pool so that we delete maximum `MAX_CONCURRENT` users in parallel.
    const promisePool = new PromisePool(
      () => deleteInactiveUser(inactiveUsers),
      MAX_CONCURRENT
    );
    await promisePool.start();
    functions.logger.log("User cleanup finished");
  });

// Deletes one inactive user from the list
const deleteInactiveUser = (inactiveUsers: firebaseAdmin.auth.UserRecord[]) => {
  if (inactiveUsers.length > 0) {
    const userToDelete = inactiveUsers.pop();

    // Delete the inactive user.
    if (userToDelete && userToDelete.email !== "test@gmail.com") {
      return firebaseAdmin
        .auth()
        .deleteUser(userToDelete.uid)
        .then(() => {
          return functions.logger.log(
            "Deleted user account",
            userToDelete.uid,
            "because of inactivity"
          );
        })
        .catch((error) => {
          return functions.logger.error(
            "Deletion of inactive user account",
            userToDelete.uid,
            "failed:",
            error
          );
        });
    }
  }
  return;
};

// Returns the list of all inactive users
const getInactiveUsers = async (
  users: firebaseAdmin.auth.UserRecord[] = [],
  nextPageToken?: string
): Promise<firebaseAdmin.auth.UserRecord[]> => {
  const result = await firebaseAdmin.auth().listUsers(1000, nextPageToken);

  // Find users that have not signed in in the last three months
  const inactiveUsers = result.users.filter(({ metadata }) => {
    if (metadata.lastRefreshTime) {
      return (
        Date.parse(metadata.lastRefreshTime) <
        Date.now() - 30 * 24 * 60 * 60 * 1000 * 3
      );
    } else return false;
  });

  // Concat with list of previously found
  // inactive users if there was more than 1000 users
  users = users.concat(inactiveUsers);

  // If there are more users to fetch we fetch them
  if (result.pageToken) {
    return getInactiveUsers(users, result.pageToken);
  }

  return users;
};
