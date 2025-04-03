# Planty - Plant Disease Diagnosis App

## 📌 Overview

[Planty](https://devsalem.tech/plant_app) is a mobile application that leverages Artificial Intelligence (AI) and Computer Vision to help farmers and agricultural specialists diagnose plant diseases instantly. By simply taking a picture of a plant leaf, users receive an instant diagnosis and the ability to purchase agricultural products directly through the app.


## Screenshots:

| Screenshot 1 | Screenshot 2 |
|-------------|-------------|
| <a href="https://ibb.co/p6h5TB1H"><img src="https://i.ibb.co/9mZS0kpx/Screenshot-20250403-213502.png" width="200"></a> | <a href="https://ibb.co/Vc6ykRxS"><img src="https://i.ibb.co/Q30BxLkN/Screenshot-20250403-213508.png" width="200"></a> |
| <a href="https://ibb.co/s4WfzbJ"><img src="https://i.ibb.co/dvmTxjJ/Screenshot-20250403-213526.png" width="200"></a> | <a href="https://ibb.co/mVV2tLRB"><img src="https://i.ibb.co/sddNQ0gP/Screenshot-20250403-213543.png" width="200"></a> |
| <a href="https://ibb.co/zT9zZCST"><img src="https://i.ibb.co/396ncV09/Screenshot-20250403-213622.png" width="200"></a> | <a href="https://ibb.co/pBmT0vT6"><img src="https://i.ibb.co/hJqN7RNx/Screenshot-20250403-213628.jpg" width="200"></a> |
| <a href="https://ibb.co/q2rQzQm"><img src="https://i.ibb.co/fTxwbwr/Screenshot-20250403-213646.png" width="200"></a> | <a href="https://ibb.co/jZQTqDw9"><img src="https://i.ibb.co/x8BDw6gK/Screenshot-20250403-213650.png" width="200"></a> |
| <a href="https://ibb.co/Dfx1b1Km"><img src="https://i.ibb.co/603yZysG/Screenshot-20250403-213702.png" width="200"></a> | <a href="https://ibb.co/JMGST4Z"><img src="https://i.ibb.co/5fSJ3yZ/Screenshot-20250403-213711.png" width="200"></a> |
| <a href="https://ibb.co/G4TCLbN4"><img src="https://i.ibb.co/rRs5S1NR/Screenshot-20250403-213720.png" width="200"></a> | <a href="https://ibb.co/9mKYCwC4"><img src="https://i.ibb.co/0p4JdBd9/Screenshot-20250403-213726.png" width="200"></a> |
| <a href="https://ibb.co/JwmpLgkB"><img src="https://i.ibb.co/fzqNRL01/Screenshot-20250403-213731.png" width="200"></a> | <a href="https://ibb.co/ZpfLxW0H"><img src="https://i.ibb.co/tTHmD89Z/Screenshot-20250403-213925.png" width="200"></a> |

## 🚀 Features

### 1️⃣ Instant AI Diagnosis
- Take a picture or upload an image of a plant.
- AI detects plant diseases, pests, or nutrient deficiencies.
- Provides instant results with treatment recommendations.

### 3️⃣ Marketplace for Agricultural Products
- Buy recommended pesticides, fertilizers, and treatments.
- Admin dashboard for managing products & orders

### 4️⃣ Diagnosis History & Tracking
- View past scans and AI-generated reports.
- Track disease trends over time.


## 🎯 Target Users
- Farmers & Growers looking for fast disease diagnosis.
- Agricultural Specialists needing AI-powered insights.
- Agriculture Companies selling pesticides and fertilizers.


### Architecture

The application follows [Riverpod/Reference Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/):

- **Presentation Layer**: Widgets, Screens, Controllers (Notifiers & Providers) for managing the state
- **Data Layer**: Repositories and Data sources
- **Domain Layer**: Models and business entities

### Project Structure

```
|- assets  <- images & app icon
|
|- lib
   |
   |_ 📁src
       |
       |__ 📁core  <- (constants, theme, shared widgets, utils)
       |
       |__ 📁auth  
       |    |
       |    |__ 📁data  <- (auth repository: sign in, sign out, getAccount, verifyOTP, etc.)
       |    |
       |    |__ 📁presentation  <- (controllers for managing state with Riverpod 2.0 & Screens/Widgets)
       |
       |__ 📁scan  
       |    |
       |    |__ 📁data  <- (scan repository: save scan, get scan, get scans, save & delete access tokens)
       |    |
       |    |__ 📁domain  <- (entities: PlantScanResponse, ScanResult, InputData, PlantStatus, Disease, etc.)
       |    |
       |    |__ 📁presentation  <- (controllers for managing state with Riverpod 2.0 & Screens/Widgets)
       |
       |__ 📁onboarding  
       |    |
       |    |__ 📁domain  <- (Onboarding Content)
       |    |
       |    |__ 📁presentation  <- (Onboarding & Welcome Screens)
       |
       |__ 📁market  
       |    |
       |    |__ 📁data  <- (AppwriteMarketRepository & IMarketplaceService: manage products, carts, and orders)
       |    |
       |    |__ 📁domain  <- (entities: Product, CartItem, Order, OrderItem)
       |    |
       |    |__ 📁presentation  <- (controllers for managing state with Riverpod 2.0 & Screens/Widgets)
       |
       |__ 📁admin  
       |    |
       |    |__ 📁data  <- (IAdminService & AppwriteAdminRepository: manage products & orders, edit, add, or delete them)
       |    |
       |    |__ 📁presentation  <- (controllers for managing state with Riverpod 2.0 & Screens/Widgets)
```

## ⚡ Installation & Setup

### 1️⃣ Clone the Repository
```
git clone https://github.com/Dev-Salem/plant_app
```

### 2️⃣ Install Dependencies & configure secrets using [envied](https://pub.dev/packages/envied)
```
flutter pub get
```
Create .env at the root director with these values:
```
ENDPOINT=https://cloud.appwrite.io/v1
PROJECT_ID=project-id-from-appwrite-console
```
### 3️⃣ Run the App
```
flutter run
```

### 4️⃣ Backend Setup (Using Appwrite)
- Sign in for [Appwrite](https://cloud.appwrite.io/)
- Create project & follow the instruction
- Create collections using Python SDK with this script:

<details>
<summary>Python script for creating collections</summary>

```python
import logging
import sys

from appwrite.client import Client
from appwrite.services.databases import Databases

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("appwrite_setup.log"),
        logging.StreamHandler(sys.stdout),
    ],
)
logger = logging.getLogger("AppwriteSetup")

# Initialize Appwrite client
client = Client()
client.set_endpoint("https://cloud.appwrite.io/v1")
client.set_project("")
client.set_key(
    ""
)
# Connect to database service
databases = Databases(client)
DATABASE_ID = "planty-db-id"


def create_products_collection():
    logger.info("🔄 Creating products collection...")
    try:
        # Check if collection exists
        try:
            collection = databases.get_collection(DATABASE_ID, "products")
            logger.info("  ✓ Products collection already exists")
        except:
            # Create the collection
            collection = databases.create_collection(
                database_id=DATABASE_ID, collection_id="products", name="Products"
            )
            logger.info("  ✓ Products collection created")

            # Create attributes based on the Product entity
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="products",
                key="name",
                size=255,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="products",
                key="description",
                size=10000,
                required=True,
            )

            databases.create_float_attribute(
                database_id=DATABASE_ID,
                collection_id="products",
                key="price",
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="products",
                key="imageUrl",
                size=2048,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="products",
                key="category",
                size=100,
                required=True,
                default="Other",
            )

            databases.create_boolean_attribute(
                database_id=DATABASE_ID,
                collection_id="products",
                key="isAvailable",
                required=True,
                default=True,
            )

            # Create indexes
            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="products",
                key="name_index",
                type="fulltext",
                attributes=["name"],
            )

            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="products",
                key="category_index",
                type="key",
                attributes=["category"],
            )

        logger.info("✅ Products collection setup complete")
        return True
    except Exception as e:
        logger.error(f"❌ Error creating products collection: {str(e)}")
        return False


def create_cart_items_collection():
    logger.info("🔄 Creating cart_items collection...")
    try:
        # Check if collection exists
        try:
            collection = databases.get_collection(DATABASE_ID, "cart_items")
            logger.info("  ✓ Cart items collection already exists")
        except:
            # Create the collection
            collection = databases.create_collection(
                database_id=DATABASE_ID, collection_id="cart_items", name="Cart Items"
            )
            logger.info("  ✓ Cart items collection created")

            # Create attributes based on the CartItem entity
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="userId",
                size=100,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="productId",
                size=100,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="productName",
                size=255,
                required=True,
            )

            databases.create_float_attribute(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="price",
                required=True,
            )

            databases.create_integer_attribute(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="quantity",
                required=True,
                min=1,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="imageUrl",
                size=2048,
                required=True,
            )

            # Create indexes
            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="userId_index",
                type="key",
                attributes=["userId"],
            )

            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="cart_items",
                key="user_product_index",
                type="key",
                attributes=["userId", "productId"],
            )

        logger.info("✅ Cart items collection setup complete")
        return True
    except Exception as e:
        logger.error(f"❌ Error creating cart items collection: {str(e)}")
        return False


def create_orders_collection():
    logger.info("🔄 Creating orders collection...")
    try:
        # Check if collection exists
        try:
            collection = databases.get_collection(DATABASE_ID, "orders")
            logger.info("  ✓ Orders collection already exists")
        except:
            # Create the collection
            collection = databases.create_collection(
                database_id=DATABASE_ID, collection_id="orders", name="Orders"
            )
            logger.info("  ✓ Orders collection created")

            # Create attributes based on the Order entity
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="userId",
                size=100,
                required=True,
            )

            databases.create_float_attribute(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="totalAmount",
                required=True,
            )

            databases.create_datetime_attribute(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="dateTime",
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="status",
                size=50,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="address",
                size=1000,
                required=False,
            )

            # Create indexes
            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="userId_index",
                type="key",
                attributes=["userId"],
            )

            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="status_index",
                type="key",
                attributes=["status"],
            )

            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="orders",
                key="dateTime_index",
                type="key",
                attributes=["dateTime"],
            )

        logger.info("✅ Orders collection setup complete")
        return True
    except Exception as e:
        logger.error(f"❌ Error creating orders collection: {str(e)}")
        return False


def create_order_items_collection():
    logger.info("🔄 Creating order_items collection...")
    try:
        # Check if collection exists
        try:
            collection = databases.get_collection(DATABASE_ID, "order_items")
            logger.info("  ✓ Order items collection already exists")
        except:
            # Create the collection
            collection = databases.create_collection(
                database_id=DATABASE_ID, collection_id="order_items", name="Order Items"
            )
            logger.info("  ✓ Order items collection created")

            # Create attributes based on the OrderItem entity
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="order_items",
                key="orderId",
                size=100,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="order_items",
                key="productId",
                size=100,
                required=True,
            )

            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id="order_items",
                key="productName",
                size=255,
                required=True,
            )

            databases.create_float_attribute(
                database_id=DATABASE_ID,
                collection_id="order_items",
                key="price",
                required=True,
            )

            databases.create_integer_attribute(
                database_id=DATABASE_ID,
                collection_id="order_items",
                key="quantity",
                required=True,
                min=1,
            )

            # Create indexes
            databases.create_index(
                database_id=DATABASE_ID,
                collection_id="order_items",
                key="orderId_index",
                type="key",
                attributes=["orderId"],
            )

        logger.info("✅ Order items collection setup complete")
        return True
    except Exception as e:
        logger.error(f"❌ Error creating order items collection: {str(e)}")
        return False


if __name__ == "__main__":
    logger.info("🚀 Starting Appwrite Plant App setup script...")

    # Create all collections
    products_result = create_products_collection()
    cart_items_result = create_cart_items_collection()
    orders_result = create_orders_collection()
    order_items_result = create_order_items_collection()

    # Print summary
    logger.info("\n📊 SETUP SUMMARY:")
    logger.info(
        f"Products collection: {'✅ SUCCESS' if products_result else '❌ FAILED'}"
    )
    logger.info(
        f"Cart items collection: {'✅ SUCCESS' if cart_items_result else '❌ FAILED'}"
    )
    logger.info(f"Orders collection: {'✅ SUCCESS' if orders_result else '❌ FAILED'}")
    logger.info(
        f"Order items collection: {'✅ SUCCESS' if order_items_result else '❌ FAILED'}"
    )

    if all([products_result, cart_items_result, orders_result, order_items_result]):
        logger.info("\n🎉 All collections created successfully!")
    else:
        logger.warning("\n⚠️ Some collections have issues. Check the logs for details.")
```
</details>

- Deploy the cloud function that connects with Crop API and the one that gets the user history (clone the function and deploy it from the console)
[Getting past diagnoses](https://github.com/Dev-Salem/get-detection)
[Creating a diagnose](https://github.com/Dev-Salem/plant-function)


## 📜 Business Model & Monetization
- Freemium Model: Free basic scans with premium features (e.g., detailed analysis).
- Marketplace Commission: Earn from product sales via partnerships with suppliers.
- Subscription Plans: Offer advanced AI-based insights for professional farmers.



## 🔮 Future Enhancements
- ✔️ Offline Mode – Enable diagnosis without internet.
- ✔️ Community Forum – Allow farmers to discuss issues.
- ✔️ Multi-language Support – Expand to other languages.

## Known Issues:
-   **The demo is deployed on github pages and is not meant for web usage**
-   images might not render because CORS issues with Crop API
-   There might be issues with other browsers other than Chrome
-   Payment for the mini market place isn't configured
-   Legal documents (like Privacy & Policy, Terms Of Use) are not presented