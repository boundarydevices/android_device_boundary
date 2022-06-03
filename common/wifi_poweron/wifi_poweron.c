#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define WIFI_POWER_UP    _IO('m', 3)
#define WIFI_POWER_DOWN  _IO('m', 4)
#define SDIO_GET_DEV_TYPE  _IO('m', 5)

int main(void)
{
	int fd;
	int ret;

	fd = open("/dev/wifi_power", O_RDWR);
	if (fd < 0) {
		printf("coudln't open wifi_power\n");
		return -EINVAL;
	}

	ret = ioctl(fd, WIFI_POWER_UP, NULL);
	if (ret < 0) {
		printf("coudln't power up wifi\n");
	}

	close (fd);

	return ret;
}
