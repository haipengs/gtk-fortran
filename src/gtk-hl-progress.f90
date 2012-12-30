! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran GTK+ Fortran Interface library.

! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.

! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! Under Section 7 of GPL version 3, you are granted additional
! permissions described in the GCC Runtime Library Exception, version
! 3.1, as published by the Free Software Foundation.

! You should have received a copy of the GNU General Public License along with
! this program; see the files COPYING3 and COPYING.RUNTIME respectively.
! If not, see <http://www.gnu.org/licenses/>.
!
! Contributed by James Tappin
! Last modification: 11-21-2011

! --------------------------------------------------------
! gtk-hl-progress.f90
! Generated: Sun Dec 30 20:53:09 2012 GMT
! Please do not edit this file directly,
! Edit gtk-hl-progress-tmpl.f90, and use ./mk_gtk_hl.pl to regenerate.
! Generated for GTK+ version: 2.24.0.
! Generated for GLIB version: 2.32.0.
! --------------------------------------------------------


module gtk_hl_progress
  !*
  ! Progress Bar
  ! Implements the GtkProgressBar widget. Includes the facility to
  ! make a bar display "n of m" as well as the usual fraction.
  !/

  use gtk_sup
  use iso_c_binding
  ! Autogenerated use's
  use gtk, only: gtk_orientable_set_orientation, gtk_progress_bar_new&
       &, gtk_progress_bar_pulse, gtk_progress_bar_set_fraction,&
       & gtk_progress_bar_set_pulse_step,&
       & gtk_progress_bar_set_text, &
       & gtk_progress_bar_set_orientation, &
!!$GTK>=3.0!       & gtk_progress_bar_set_show_text, &
!!$GTK>=3.0!       & gtk_progress_bar_set_inverted, &
   & GTK_PROGRESS_LEFT_TO_RIGHT, GTK_PROGRESS_BOTTOM_TO_TOP, &
   & GTK_PROGRESS_TOP_TO_BOTTOM, GTK_PROGRESS_RIGHT_TO_LEFT, &
!!$GTK>=3.0!   & GTK_ORIENTATION_VERTICAL,  GTK_ORIENTATION_HORIZONTAL, &
       & TRUE, FALSE

  implicit none

  ! A progress bar value can be given as a fraction or m of n
  interface hl_gtk_progress_bar_set
     module procedure  hl_gtk_progress_bar_set_f
     module procedure  hl_gtk_progress_bar_set_ii
  end interface hl_gtk_progress_bar_set

contains

  !+
  function hl_gtk_progress_bar_new(vertical, reversed, step) result(bar)

    type(c_ptr) :: bar
    integer(kind=c_int), optional :: vertical, reversed
    real(kind=c_double), optional :: step

    ! Intializer for a progress bar
    !
    ! VERTICAL: boolean: optional: The orientation of the bar.
    ! REVERSED: boolean: optional: Whether the direction of the bar should
    ! 		be reversed.
    ! STEP: double: optional: The fractional step to advance when
    ! 		pulsing the bar
    !-

    integer(kind=c_int) :: orientation

    bar = gtk_progress_bar_new()

    ! GTK2 version
    orientation = GTK_PROGRESS_LEFT_TO_RIGHT
    if (present(vertical)) then
       if (vertical == TRUE) orientation = GTK_PROGRESS_BOTTOM_TO_TOP
       if (present(reversed)) then
          if (reversed == TRUE) orientation = GTK_PROGRESS_TOP_TO_BOTTOM
       end if
    else if (present(reversed)) then
       if (reversed == TRUE) orientation = GTK_PROGRESS_RIGHT_TO_LEFT
    end if
    call gtk_progress_bar_set_orientation(bar, orientation)
    ! end GTK2 version
    ! GTK3 version
!!$GTK>=3.0!    if (present(vertical)) then
!!$GTK>=3.0!       if (vertical == TRUE) then
!!$GTK>=3.0!          call gtk_orientable_set_orientation (bar, &
!!$GTK>=3.0!               & GTK_ORIENTATION_VERTICAL)
!!$GTK>=3.0!       else
!!$GTK>=3.0!          call gtk_orientable_set_orientation (bar, &
!!$GTK>=3.0!               & GTK_ORIENTATION_HORIZONTAL)
!!$GTK>=3.0!       end if
!!$GTK>=3.0!    end if
!!$GTK>=3.0!
!!$GTK>=3.0!    if (present(reversed)) call gtk_progress_bar_set_inverted(bar, reversed)
    ! end GTK3 version

    if (present(step)) &
         & call gtk_progress_bar_set_pulse_step(bar, step)

  end function hl_gtk_progress_bar_new

  !+
  subroutine hl_gtk_progress_bar_set_f(bar, val, string, text)

    type(c_ptr) :: bar
    real(kind=c_double), optional :: val
    integer(kind=c_int), optional :: string
    character(len=*), intent(in), optional:: text

    ! Set the value of a progress bar (fraction or pulse)
    !
    ! BAR: c_ptr: required: The bar to set
    ! VAL: double: optional: The value to set. If absent, the bar is pulsed
    ! STRING: boolean: optional: Whether to put a string on the bar.
    ! TEXT: string: optional: Text to put in the bar, (overrides STRING)
    !
    ! This routine is normally accessed via the generic interface
    ! hl_gtk_progress_bar_set
    !-

    character(len=50) :: sval

    ! If no value given pulse the bar
    if (.not. present(val)) then
       call gtk_progress_bar_pulse(bar)
    else
       ! Determine the fraction to fill & fill it
       call gtk_progress_bar_set_fraction(bar, val)
    end if

    ! If annotation is needed, add it.
    if (present(text)) then
       call gtk_progress_bar_set_text (bar, text//c_null_char)
! GTK3 Only
!!$GTK>=3.0!      call gtk_progress_bar_set_show_text(bar, TRUE)
! End GTK3 only
    else if (present(string)) then
       if (string == FALSE .or. .not. present(val)) return
       ! Otherwise we display a percentage
       write(sval, "(F5.1,'%')") val*100.

       call gtk_progress_bar_set_text (bar, trim(sval)//c_null_char)
! GTK3 Only
!!$GTK>=3.0!      call gtk_progress_bar_set_show_text(bar, TRUE)
!!$GTK>=3.0!    else
!!$GTK>=3.0!       call gtk_progress_bar_set_show_text(bar, FALSE)
! End GTK3 only
    end if
  end subroutine hl_gtk_progress_bar_set_f

  !+
  subroutine hl_gtk_progress_bar_set_ii(bar, val, maxv, string, text)

    type(c_ptr) :: bar
    integer(kind=c_int) :: val, maxv
    integer(kind=c_int), optional :: string
    character(len=*), intent(in), optional:: text

    ! Set the value of a progress bar (n of m)
    !
    ! BAR: c_ptr: required: The bar to set
    ! VAL: int: required: The value to set.
    ! MAXV: int: required: The maximum value for the bar
    ! STRING: boolean: optional: Whether to put a string on the bar.
    ! TEXT: string: optional: Text to put in the bar, (overrides STRING)
    !
    ! This routine is normally accessed via the generic interface
    ! hl_gtk_progress_bar_set
    !-

    real(kind=c_double) :: frac
    character(len=50) :: sval

    frac = real(val,c_double)/real(maxv,c_double)
    call gtk_progress_bar_set_fraction(bar, frac)

    ! If annotation is needed, add it.
    if (present(text)) then
       call gtk_progress_bar_set_text (bar, text//c_null_char)
! GTK3 Only
!!$GTK>=3.0!       call gtk_progress_bar_set_show_text(bar, TRUE)
! End GTK3 only
    else if (present(string)) then
       if (string == FALSE) return
       ! Otherwise we display n or m
       write(sval, "(I0,' of ',I0)") val, maxv
       call gtk_progress_bar_set_text (bar, trim(sval)//c_null_char)
! GTK3 Only
!!$GTK>=3.0!       call gtk_progress_bar_set_show_text(bar, TRUE)
!!$GTK>=3.0!    else
!!$GTK>=3.0!       call gtk_progress_bar_set_show_text(bar, FALSE)
! End GTK3 only
    end if
  end subroutine hl_gtk_progress_bar_set_ii
end module gtk_hl_progress
