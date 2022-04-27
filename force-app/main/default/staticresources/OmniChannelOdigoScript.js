sforce.interaction.setVisible(false);
/*
 * Function called to manage message received whil long polling
 * Store value in javascript context and in cookie also
 * Refresh buttons
 */
Odigo.Softphone.manageMessage = function(pMessage) {
        //handle message here
        if (pMessage != null) {
                // set value to cookie
                if (pMessage.data != null) {
                        console.log("############OVERIDE############# message arrived : " + pMessage.data.state + ' / ' + pMessage.data.customerPhoneNumber);
                        console.log(pMessage);
                        mCurrentState = pMessage.data.state + '';
                        Odigo.Softphone.setStateValueInCookie(pMessage.data.state);
                        // Check if logon is in progress
                        if (mCurrentState != "200" || (mCurrentState == "200" && sessionStorage.getItem('Odigo_doNotCareNextMessage') != "true")) {
                                // remove flag logging in
                                sessionStorage.setItem('Odigo_doNotCareNextMessage', 'false');
                                // Set specials flags (like records flags)
                                Odigo.Softphone.setSpecialFlags(pMessage);
                                // Update buttons and states
                                Odigo.Softphone.refreshButtons();
                                // Specials actions
                                Odigo.Softphone.manageMessageSpecialsStateAction(pMessage);
                                // Update status
                                Odigo.Softphone.setStatus(pMessage);
                                // Has to be after set Status to get value in states ddl
                                Odigo.Softphone.setButtonPhone(pMessage);
                        }
                }
                // Ofize: Hide Loupe manual Search at any case
                var vSufix = (mIsHorizontal ? '-h' : '');
                var iconSearchClient = document.getElementById('VFP02OdigoCTI:formCallWS:info-tel3-icon' + vSufix);
                if (iconSearchClient && Odigo.Softphone.getCallerPhoneNumber() != null) {
                        iconSearchClient.style.display = 'none';
                }

                // Ofize: Popup Up on Oubound Communication 
                if (mCurrentState == "216" && mPreviousState != "216" && mPreviousState != "222") {
                        sforce.console.presence.setServicePresenceStatus("0N5w0000000blLA"); //Id Omni Status Z_i_samtale
                }

                // Ofize: Popup Up on Inbound Communication 
                if (mCurrentState == "206" && mPreviousState != "206" && mPreviousState != "222") {
                        sforce.console.presence.setServicePresenceStatus("0N5w0000000blLA"); //Id Omni Status Z_i_samtale
                }

                // Ofize: Popup Up on Inbound Communication (when the agent is selected for a call)
                if (mCurrentState == "208" && mPreviousState != "208" && mPreviousState != "222") {
                        //alert("ofize CTI Popup:"+mPreviousState+"/"+mCurrentState);
                        mPreviousState = mCurrentState;
                        searchAndScreenPop(Odigo.Softphone.getCallerPhoneNumber(), Odigo.Softphone.getFolderNumber(), localStorage.getItem(ODIGO_CALL_SKILL));
                        sforce.interaction.setVisible(true);
                }

                mPreviousState = mCurrentState;
        }
}
var mPreviousState = "";




var mOdigoAvailableStatusIdMapping = [{
                'status': '0N5w0000000blKv',
                'default': true
        }, // Busy_Tilgjengelig_Telefon
        {
                'status': '0N5w0000000blL5',
                'default': false
        }, // Online_Tilgjengelig_Telefon_og_Saker_K
        {
                'status': '0N5w0000000blL0',
                'default': false
        } // Online_Tilgjengelig_Telefon_og_Saker
];


var mOmniChannelStatusIdMapping = [{
                'match': '0N5w0000000blKb',
                'status': '1',
                'default': true
        }, //Busy, Teammote/Opplaering
        {
                'match': '0N5w0000000blKR',
                'status': '2',
                'default': true
        }, //Busy, Opptatt med sak
        {
                'match': '0N5w0000000blKM',
                'status': '4',
                'default': true
        }, //Busy, Etterarbeid
        {
                'match': '0N5w0000000blKl',
                'status': '7',
                'default': true
        }, //Online, Tilgjengelig Chat og Saker
        {
                'match': '0N5w0000000blKW',
                'status': '10',
                'default': true
        }, //Busy, Pause
        {
                'match': '0N5w0000000blKg',
                'status': '13',
                'default': true
        }, //Online, Tilgjengelig Chat
        {
                'match': '0N5w0000000blKq',
                'status': '14',
                'default': true
        } //Online, Tilgjengelig Saker
];