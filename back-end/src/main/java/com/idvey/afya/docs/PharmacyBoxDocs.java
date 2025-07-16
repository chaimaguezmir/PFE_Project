package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import java.lang.annotation.*;

@Tag(name = "Pharmacy Box", description = "Pharmacy box management")
public final class PharmacyBoxDocs {

    private PharmacyBoxDocs() {} // no instantiation

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get my pharmacy boxes", description = "Retrieves all pharmacy boxes accessible to the current user")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Pharmacy boxes retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.PharmacyBoxResponse.class))),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetMyPharmacyBoxes {}
}