/* 
 * Copyright (c) 2016, Boundary Devices
 * Copyright (c) 2011, RidgeRun
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *    This product includes software developed by the RidgeRun.
 * 4. Neither the name of the RidgeRun nor the
 *    names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY RIDGERUN ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL RIDGERUN BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>

#include <android/log.h>
#include <cutils/properties.h>

#define SYSFS_GPIO_DIR "/sys/class/gpio"
#define POLL_TIMEOUT (-1) /* infinite */
#define MAX_BUF 64

/* Define Log macros */
#define  LOG_TAG    "powerfail"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

int gpio_export(unsigned int gpio)
{
	int fd, len;
	char buf[MAX_BUF];

	fd = open(SYSFS_GPIO_DIR "/export", O_WRONLY);
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
		return fd;
	}

	len = snprintf(buf, sizeof(buf), "%d", gpio);
	write(fd, buf, len);
	close(fd);

	return 0;
}

int gpio_unexport(unsigned int gpio)
{
	int fd, len;
	char buf[MAX_BUF];

	fd = open(SYSFS_GPIO_DIR "/unexport", O_WRONLY);
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
		return fd;
	}

	len = snprintf(buf, sizeof(buf), "%d", gpio);
	write(fd, buf, len);
	close(fd);
	return 0;
}

int gpio_set_dir(unsigned int gpio, unsigned int out_flag)
{
	int fd, len;
	char buf[MAX_BUF];

	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR 
		       "/gpio%d/direction", gpio);

	fd = open(buf, O_WRONLY);
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
		return fd;
	}

	if (out_flag)
		write(fd, "out", 4);
	else
		write(fd, "in", 3);

	close(fd);
	return 0;
}

int gpio_set_value(unsigned int gpio, unsigned int value)
{
	int fd, len;
	char buf[MAX_BUF];

	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/value", gpio);

	fd = open(buf, O_WRONLY);
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
		return fd;
	}

	if (value)
		write(fd, "1", 2);
	else
		write(fd, "0", 2);

	close(fd);
	return 0;
}

int gpio_get_value(unsigned int gpio, unsigned int *value)
{
	int fd, len;
	char buf[MAX_BUF];
	char ch;

	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/value", gpio);

	fd = open(buf, O_RDONLY);
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
		return fd;
	}

	read(fd, &ch, 1);

	if (ch != '0') {
		*value = 1;
	} else {
		*value = 0;
	}

	close(fd);
	return 0;
}


int gpio_set_edge(unsigned int gpio, char *edge)
{
	int fd, len;
	char buf[MAX_BUF];

	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/edge", gpio);

	fd = open(buf, O_WRONLY);
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
		return fd;
	}

	write(fd, edge, strlen(edge) + 1); 
	close(fd);
	return 0;
}

int gpio_fd_open(unsigned int gpio)
{
	int fd, len;
	char buf[MAX_BUF];

	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/value", gpio);

	LOGD("opening %s", buf);
	fd = open(buf, O_RDONLY | O_NONBLOCK );
	if (fd < 0) {
		LOGE("%s failed: %s", __func__, strerror(errno));
	}
	return fd;
}

int gpio_fd_close(int fd)
{
	return close(fd);
}

void process_event(int fd)
{
	int len;
	char buf[MAX_BUF];

	/* As said in sysfs.txt:
	 * After poll(2) returns, either lseek(2) to the
	 * beginning of the sysfs file and read the new value
	 * or close the file and re-open it to read the value.
	 */
	lseek(fd, 0, SEEK_SET);
	len = read(fd, buf, sizeof(buf));
	if (!len || (buf[0] != '0'))
		return;

	LOGD("interrupt occurred, len %d, value %c", len, buf[0]);

	/* Wait for 500ms to make sure it's not a glitch */
	usleep(500000);
	lseek(fd, 0, SEEK_SET);
	len = read(fd, buf, sizeof(buf));
	if (!len || (buf[0] != '0'))
		return;

	/* Power failure GPIO has been down for 500ms */
	LOGI("Initiate system shutdown!");
	sync();
	property_set("sys.powerctl", "shutdown");
}

int main(int argc, char *argv[])
{
	struct pollfd fdset[1];
	int nfds = 1;
	int gpio_fd;
	int rc;
	unsigned int gpio;

	if (argc < 2) {
		printf("Usage: %s <gpio-pin>\n\n", argv[0]);
		printf("Waits for a change in the GPIO pin voltage level"
		       "to initiate a proper OS shutdown\n");
		exit(-1);
	}

	gpio = atoi(argv[1]);

	if (gpio_export(gpio) != 0)
		return -1;

	if (gpio_set_dir(gpio, 0) != 0)
		return -1;

	if (gpio_set_edge(gpio, "falling") != 0)
		return -1;

	if ((gpio_fd = gpio_fd_open(gpio)) < 0)
		return -1;

	while (1) {
		fdset[0].fd = gpio_fd;
		fdset[0].events = POLLPRI;
		fdset[0].revents = 0;
		rc = poll(fdset, nfds, POLL_TIMEOUT);      
		if (rc < 0) {
			LOGE("poll() failed: %s", strerror(errno));
			return -1;
		}

		if (rc == 0) {
			LOGE("Timed out?\n");
			continue;
		}

		if (fdset[0].revents & POLLPRI) {
			process_event(gpio_fd);
		}
	}

	gpio_fd_close(gpio_fd);

	return 0;
}
