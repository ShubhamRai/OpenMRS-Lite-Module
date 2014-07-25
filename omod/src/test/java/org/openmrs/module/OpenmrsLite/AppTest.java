package org.openmrs.module.OpenmrsLite;

import org.junit.Test;
import org.openmrs.module.appframework.AppTestUtil;
import org.openmrs.module.appframework.domain.AppDescriptor;
import org.openmrs.module.appframework.domain.AppTemplate;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

/**
 *
 */
public class AppTest {

    @Test
    public void testFindPatientAppTemplateIsLoaded() throws Exception {
        AppTemplate template = AppTestUtil.getAppTemplate("OpenmrsLite.template.findPatient");
        assertThat(template.getConfigOptions().get(0).getName(), is("afterSelectedUrl"));
    }

    @Test
    public void testFindPatientAppIsLoaded() throws Exception {
        AppDescriptor app = AppTestUtil.getAppDescriptor("OpenmrsLite.findPatient");
        assertThat(app.getOrder(), is(2));
        assertThat(app.getInstanceOf(), is("OpenmrsLite.template.findPatient"));
        assertThat(app.getTemplate().getId(), is("OpenmrsLite.template.findPatient"));
        String expectedUrl = app.getTemplate().getConfigOptions().get(0).getDefaultValue().getTextValue();
        assertThat(app.getConfig().get("afterSelectedUrl").getTextValue(), is(expectedUrl));
        String expectedLabel = app.getTemplate().getConfigOptions().get(1).getDefaultValue().getTextValue();
        assertThat(app.getConfig().get("label").getTextValue(), is(expectedLabel));
        String expectedHeading = app.getTemplate().getConfigOptions().get(2).getDefaultValue().getTextValue();
        assertThat(app.getConfig().get("heading").getTextValue(), is(expectedHeading));
    }

    @Test
    public void testFindPatientAppHasHomepageExtension() throws Exception {
        AppDescriptor app = AppTestUtil.getAppDescriptor("OpenmrsLite.findPatient");
        assertThat(app.getExtensions(), hasSize(1));
        assertThat(app.getExtensions().get(0).getExtensionPointId(), is("org.openmrs.OpenmrsLite.homepageLink"));
    }

}
