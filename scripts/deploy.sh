#!/bin/bash
export PATH=$PATH:/path/to/google-cloud-sdk/bin

handle_error() {

  echo "Error: $1"

  exit 1

}

# Get version from user

read -p "Enter version: " version

# Get commit hash from user

read -p "Enter commit hash: " commit_hash

# Check if image exists

if docker image inspect chat-app:$version >/dev/null 2>&1; then

  read -p "Image chat-app:$version already exists. Do you want to rebuild? [y/n]: " rebuild

  if [ "$rebuild" == "y" ]; then

    # Delete existing image

    docker image rm chat-app:$version || handle_error "Failed to delete existing image"

  else

    echo "Using existing image chat-app:$version"

    exit 0

  fi

fi

# Tag the commit

git tag "$version" "$commit_hash" || handle_error "Failed to tag the commit"

# Build the image

docker build -t chat-app:$version . || handle_error "Failed to build the image"

# Push the tag to GitHub repository

git push origin "$version" || handle_error "Failed to push to GitHub"

# Success message



# Ask user if they want to push the image to Artifact Registry
read -p "Do you want to push the image to Artifact Registry? (y/n): " push_image

if [ "$push_image" == "y" ]; then
  # Authenticate with service account impersonation
  #gcloud auth configure-docker us-east1-docker.pkg.dev
  #gcloud auth activate-service-account --key-file=/path/to/service-account-key.json --impersonate-service-account=artifact-admin-sa@grunitech-mid-project.iam.gserviceaccount.com



appname="chat-app"
   # Push the Docker image to Artifact Registry (optional)
echo "Pushing Docker image to artifactregistry"
gcloud config set auth/impersonate_service_account artifact-admin-sa@grunitech-mid-project.iam.gserviceaccount.com  
gcloud auth configure-docker me-west1-docker.pkg.dev
artifact_registry_image=me-west1-docker.pkg.dev/grunitech-mid-project/tovar-chat-app-images/${appname}:${Version}
docker tag ${image_name} ${artifact_registry_image} 
docker push ${artifact_registry_image}
  # Push the image to Artifact Registry


  echo "Image pushed to Artifact Registry."
else
  echo "Skipping image push to Artifact Registry."
fi

# Other deployment steps...
# Add your custom deployment steps here

echo "Deployment completed successfully."


echo "Deployment successful!"