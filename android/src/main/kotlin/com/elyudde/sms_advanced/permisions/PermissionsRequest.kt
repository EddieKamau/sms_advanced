package com.elyudde.sms_advanced.permisions

import android.annotation.TargetApi
import android.app.Activity
import android.os.Build


/**
 * Created by crazygenius on 1/08/21.
 */
internal class PermissionsRequest(
    private val id: Int,
    private val permissions: Array<String>,
    private val activity: Activity
) {
    @TargetApi(Build.VERSION_CODES.M)
    fun execute() {
        activity.requestPermissions(permissions, id)
    }
}
