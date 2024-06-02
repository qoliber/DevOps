#!/bin/bash

welcome() {
  # Display the dialog with centered text
  # Define welcome text
  welcome_text="\n
*                   Welcome to the Qoliber Installation Wizard                       *\n
*                 This wizard will guide you through the setup process               *\n
*  Installations scripts were adjusted to run on Ubuntu Server 20.04 and 22.04.      *\n\n\n
*                                                                ##%                 *\n
*                                                             ###                    *\n
*                                                 %######%####                       *\n
*                                               ###########                          *\n
*                                              ####  ####                            *\n
*                                              ##   ###                              *\n
*                                              #    ###                              *\n
*                                                   ###%                             *\n
*                       ###################          ####                            *\n
*                  ############%      ########        ###                            *\n
*                            ------------- #####      ###                            *\n
*                               -----------  ####     ###                            *\n
*                                     ------  ###     ###                            *\n
*                                      -----  ###    ####                            *\n
*                                       ---   ###    ###                             *\n
*                                       --   ####  ####                              *\n
*                                      --    ###  ####                               *\n
*                                      -    ###  ###%                                *\n
*                                          ###%####                                  *\n
*                                        #########                                   *\n
*                                      #########                                     *\n
*                                     ########                                       *\n
*                                    ######                                          *\n
*                                   #####                                            *\n
*                                  ##                                                *\n"

  dialog --msgbox "$welcome_text" 36 90

  # Clear the screen after the dialog is closed
  local result=$?
  DOMAIN=$(<domain.txt)
  rm domain.txt

  return $result
}