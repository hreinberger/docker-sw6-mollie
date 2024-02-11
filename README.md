# Mollie Shopware 6 Plugin Showcase

This is a ready to use showcase Docker image to play around with the Mollie plugin for Shopware 6.

All you need to do is to install Docker on your machine and run this Docker image. That's it.
You can immediately add your Mollie API key in the plugin configuration and start your checkout.

```bash 
docker run --rm -p 80:80 boxblinkracer/shopware6-mollie
```

After the image is downloaded and started you can access the storefront using http://localhost.

The Administration can be found at http://localhost/admin with username **admin** and password **shopware**.

### Configure API Key

Open the Shopware Administration and navigate to Extensions > My Extensions in the sidebar.

Press the 3 dots in the Mollie plugin row and click on configure.

Now just place your Test API key in the corresponding field and press save.

The Test API key can also be set using an environment variable.

```bash 
docker run --rm -p 80:80 --env MOLLIE_TEST_API_KEY=test_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx boxblinkracer/shopware6-mollie
```

You can of course use all other features of the Mollie plugin as well.

### Start Checkout

The showcase image is already pre-configured for you.
All payment methods are already enabled and assigned to the Sales Channels (normally this needs to be done manually).

Also some additional products for edge cases are already installed for you.

Place an item to the cart, select a Mollie payment method and start your checkout.
You should already come to the Mollie sandbox page in test mode.

### See Logs

In case of errors or problems, just open the url http://localhost/logs.

In the center of the top navigation bar, just click on "Apache Access Logs" which is usually selected by default.
This is a dropdown. Just select the Mollie logs and that's it.

### How it's built

This showcase image is built using dockware.io and the Shopware 6 plugin for Mollie.
Every feature from dockware is part of this image.

The image is built every night, so you usually always have access to the latest Shopware version
or Mollie version, once one of them is released.

### Reliability

Although I'm one of the creators and maintainers of the Mollie plugins,
this is a private and community project.

No reliability or warranty is given for this image.
