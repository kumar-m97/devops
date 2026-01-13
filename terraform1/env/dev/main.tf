module "networking-setup" {
    source = ../modules/networking/main.tf

    vpc-name        = var.VPC-NAME
    vpc-cidr        = var.VPC-CIDR
    igw-name        = var.IGW-NAME
    public-cidr1    = var.PUBLIC-CIDR1
    public-subnet1  = var.PUBLIC-SUBNET1
    private-cidr1   = var.PRIVATE-CIDR1
    private-subnet1 = var.PRIVATE-SUBNET1
    eip-name1       = var.EIP-NAME1

    ngw-name1        = var.NGW-NAME1
    public-rt-name1  = var.PUBLIC-RT-NAME1
    private-rt-name1 = var.PRIVATE-RT-NAME1

}