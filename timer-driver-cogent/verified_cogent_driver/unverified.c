#include "meson_timer.h"

#include <errno.h>
#include <stdlib.h>
#include <utils/util.h>
#include <platsupport/timer.h>
#include <platsupport/plat/meson_timer.h>
#include "generated/driver.c"

/*

The device contains 5 timers, A,B C,D,E, but the driver only use timer A and E.
Timer E is a chronomoter while timer A is a countdown.

*/
int meson_init(meson_timer_t *timer, meson_timer_config_t config)
{
    // This won't appear in the cogent code (we assume that
    // we are given non null pointers
    if (timer == NULL || config.vaddr == NULL) {
        return EINVAL;
    }

    timer->regs = (void *)((uintptr_t) config.vaddr + (TIMER_BASE + TIMER_REG_START * 4 - TIMER_MAP_BASE));
    meson_init_cogent((Meson_timer *) timer);
    return 0;
}

uint64_t meson_get_time(meson_timer_t *timer) {
    return meson_get_time_cogent((Meson_timer *) timer);
}
void meson_set_timeout(meson_timer_t *timer, uint16_t timeout, bool periodic) {
    meson_set_timeout_cogent ((TimeoutInput) { (Meson_timer *) timer, timeout, periodic });
}
void meson_stop_timer(meson_timer_t *timer) {
    meson_stop_timer_cogent((Meson_timer*) timer);
}
