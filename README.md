# AWS Datasync from On Prem to S3

Demonstrate capability to move data from on-premise to AWS S3 by using [AWS DataSync](https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html)

# On-Prem Setup
I am using my local MacBook to simulate an on-prem server.
- [x] Install VMWare's [Fusion Pro](https://blogs.vmware.com/teamfusion/2024/05/fusion-pro-now-available-free-for-personal-use.html) product
- [x] Setup your VM using the provided VMWare ESXi image from AWS Datasync ![Image](./assets/vmware_image.png)
- [x] Create a new VM by selecting ![Import an Existing Machine](./assets/import.png) and you will be able to select the previous VMWare ESXi image you downloaded
