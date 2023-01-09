#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <linux/ioctl.h>
#include <linux/spi/spidev.h>
#include <linux/types.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define XRES 160
#define YRES 68
#define BPL (XRES/8)
#define DISPBYTES (YRES*BPL)

static unsigned char bmpdata[DISPBYTES];
static void pabort(char const *msg)
{
	fprintf(stderr, "%s\n", msg);
	abort();
}

static void transfer_file(int fdspi, char const *filename)
{
	struct stat sb;
	int fdbmp, numread, numwrote, offs;

	if (stat(filename, &sb) == -1)
		pabort("can't stat input file");

	if (sb.st_size != DISPBYTES) {
		printf("%lu bytes != display(%u)\n",
		       sb.st_size, DISPBYTES);
		pabort("try again");
	}

	fdbmp = open(filename, O_RDONLY);
	if (0 > fdbmp)
		pabort(filename);

	numread = read(fdbmp, bmpdata, sizeof(bmpdata));
	if (DISPBYTES != numread) {
		printf("Error %d reading %s\n", errno, filename);
		pabort("read error");
	}

	offs = 0;
	while (offs < DISPBYTES) {
		numwrote = write(fdspi, bmpdata+offs, sizeof(bmpdata)-offs);
		if (0 >= numwrote) {
			printf("Error %d:%d sending %s\n", errno, numwrote, filename);
			pabort("write error");
		}
		offs += numwrote;
	}

	close(fdbmp);
}

static const char * const device = "/dev/aux-display";
int main (int argc, char const *argv[])
{
	if (2 <= argc) {
		int arg, fdspi;

		fdspi = open(device, O_RDWR);
		if (fdspi < 0)
			perror("can't open device");
		
		for (arg=1; arg < argc; arg++) {
			transfer_file(fdspi, argv[arg]);
		}

		close(fdspi);
	}
	return 0;
}
