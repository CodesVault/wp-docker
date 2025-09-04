#!/bin/bash

# Create build directory
BUILD_DIR="build"
BINARY_NAME="wp-docker"

echo "Creating build directory..."
# remove existing wp-docker binary
mkdir -p "$BUILD_DIR"
rm -f "$BUILD_DIR/$BINARY_NAME"

# Create a temporary combined script
TEMP_SCRIPT="$BUILD_DIR/combined_script.sh"

echo "Combining all scripts..."

# Start with shebang and header
cat > "$TEMP_SCRIPT" << 'EOF'
#!/bin/bash

# Combined WP-Docker Script
# Developed by CodesVault <https://github.com/CodesVault>
# Author: Keramot UL Islam <https://abmsourav.com>

EOF

# Add embedded Docker configuration files
echo "Embedding Docker configuration files..."

# Function to encode file content in base64 and add to script
embed_file() {
    local file_path="$1"
    local var_name="$2"
    
    if [ -f "$file_path" ]; then
        echo "Embedding $file_path as $var_name..."
        echo "" >> "$TEMP_SCRIPT"
        echo "# Embedded file: $file_path" >> "$TEMP_SCRIPT"
        echo "$var_name=\"$(base64 -i "$file_path" | tr -d '\n')\"" >> "$TEMP_SCRIPT"
    else
        echo "Warning: $file_path not found"
    fi
}

# Embed all Docker configuration files
embed_file "master_docker/docker-compose.yml" "DOCKER_COMPOSE_YML"
embed_file "master_docker/configs/app.dockerfile" "APP_DOCKERFILE"
embed_file "master_docker/configs/nginx.dockerfile" "NGINX_DOCKERFILE"
embed_file "master_docker/configs/php.ini" "PHP_INI"
embed_file "master_docker/configs/nginx/default.conf" "NGINX_CONF"

# Add helper function to create files from embedded content
cat >> "$TEMP_SCRIPT" << 'EOF'

# Helper function to create files from embedded base64 content
create_docker_files() {
    local target_dir="$1"
    
    mkdir -p "$target_dir/configs/nginx"
    
    # Create docker-compose.yml
    echo "$DOCKER_COMPOSE_YML" | base64 -d > "$target_dir/docker-compose.yml"
    
    # Create dockerfiles and configs
    echo "$APP_DOCKERFILE" | base64 -d > "$target_dir/configs/app.dockerfile"
    echo "$NGINX_DOCKERFILE" | base64 -d > "$target_dir/configs/nginx.dockerfile"
    echo "$PHP_INI" | base64 -d > "$target_dir/configs/php.ini"
    echo "$NGINX_CONF" | base64 -d > "$target_dir/configs/nginx/default.conf"
}

EOF

# Function to add a file with proper function wrapping
add_file_content() {
    local file_path="$1"
    
    if [ -f "$file_path" ]; then
        echo "Adding $file_path..."
        echo "" >> "$TEMP_SCRIPT"
        echo "# Content from $file_path" >> "$TEMP_SCRIPT"
        
        # Remove shebang and source statements, add content
        if [[ "$file_path" == "cli/generate_files" ]]; then
            # Replace the generate_files content to use embedded Docker files
            cat >> "$TEMP_SCRIPT" << 'EOF'

DOMAIN=$1
PHP_VERSION=$2
NODEJS_VERSION=$3

function generate_env {
    local target_dir="$1"
    
    PORT=`random_port 3000`
    mysql_port=`random_port 4000`
    phpmyadmin_port=`random_port 5000`

   cat > "$target_dir/.env" << EOL
APP=$DOMAIN
DOMAIN=$DOMAIN.test
HTTP_PORT=$PORT
MYSQL_PORT=$mysql_port
PHPMYADMIN_PORT=$phpmyadmin_port

PHP_VERSION=$PHP_VERSION
NODEJS_VERSION=$NODEJS_VERSION

MYSQL_DATABASE=wp
MYSQL_USER=wp
MYSQL_PASSWORD=secret
MYSQL_ROOT_PASSWORD=secret
EOL

    if [ `uname` != 'Darwin' ]; then
        User=`whoami`
        sudo chown $User:$User "$target_dir/.env"
    fi
}

function generate_files {
    Current_Dir=`pwd`/$DOMAIN
    mkdir -p "$Current_Dir"
    
    # Create Docker files from embedded content
    create_docker_files "$Current_Dir"

    # Generate .env file
    echo 
    printLn "Generating env"
    generate_env "$Current_Dir"
}
EOF
        elif [[ "$file_path" == "cli/bingo" ]]; then
            # Special handling for bingo to remove source statements
            sed '1{/^#!/d;}; /^source.*cli\//d' "$file_path" >> "$TEMP_SCRIPT"
        else
            # For other files, remove shebang and source statements
            sed '1{/^#!/d;}; /^source.*cli\//d' "$file_path" >> "$TEMP_SCRIPT"
        fi
        echo "" >> "$TEMP_SCRIPT"
    else
        echo "Warning: $file_path not found"
    fi
}

# Add all CLI dependencies in proper order
add_file_content "cli/ui"
add_file_content "cli/random_port"
add_file_content "cli/routes"
add_file_content "cli/get_inputs"
add_file_content "cli/update_hosts"
add_file_content "cli/generate_files"  # This will be modified to use embedded files
add_file_content "cli/docker_environment"
add_file_content "cli/prepare_wp"
add_file_content "cli/congrats"

# Add the main bingo function
add_file_content "cli/bingo"

# Add main execution logic (from codesvault)
cat >> "$TEMP_SCRIPT" << 'EOF'

# Main execution
function main {
    bingo $1
}

# Execute main function with all arguments
main "$@"
EOF

echo "Making combined script executable..."
chmod +x "$TEMP_SCRIPT"

# Create binary using shc
echo "Creating binary with shc..."
if command -v shc &> /dev/null; then
    shc -f "$TEMP_SCRIPT" -o "$BUILD_DIR/$BINARY_NAME"
    
    if [ $? -eq 0 ]; then
        echo "Binary created successfully: $BUILD_DIR/$BINARY_NAME"
        
        # Clean up temporary files
        rm -f "$TEMP_SCRIPT"
        rm -f "$BUILD_DIR/combined_script.sh.x.c"
        
        echo "Build completed successfully!"
        echo "Binary location: $(pwd)/$BUILD_DIR/$BINARY_NAME"
        
        # Make binary executable
        chmod +x "$BUILD_DIR/$BINARY_NAME"
        
        # Test the binary
        echo ""
        echo "Testing binary..."
        if "$BUILD_DIR/$BINARY_NAME" --routes 2>/dev/null; then
            echo "Binary test passed!"
        else
            echo "Binary created but test failed. Please check manually."
        fi
        
    else
        echo "Error: Failed to create binary with shc"
        exit 1
    fi
else
    echo "Error: shc not found. Please install shc first."
    echo "On macOS: brew install shc"
    echo "On Ubuntu: sudo apt-get install shc"
    exit 1
fi
